class ElasticWrapper
  @@indices = []
  @@models = {}
  @@elasticClasses = {}

  Myp.process_models do |klass|
    string_columns = []
    text_columns = []
    integer_columns = []
    klass.columns.each do |column|
      if column.type == :string || column.type == :text
        if klass.instance_methods.index("#{column.name}_encrypted?".to_sym).nil?
          if column.type == :text
            text_columns.push(column)
          else
            string_columns.push(column)
          end
        end
      elsif column.type == :integer && column.name.index("_id").nil?
        integer_columns.push(column)
      elsif column.type != :integer && column.type != :datetime && column.type != :date && column.type != :boolean && column.type != :decimal && column.type != :binary && column.type != :inet
        # TODO enforce https://www.elastic.co/blog/great-mapping-refactoring
      end
    end
    
    indexName = "#{klass.name}Index"
      
    # Only create a type if it has some text fields
    if !indexName.include?("::") && (string_columns.length > 0 || text_columns.length > 0) && (!klass.respond_to?("searchable?") || (klass.respond_to?("searchable?") && klass.searchable?))
      
      #Rails.logger.debug{"Creating Elastic index: #{indexName}"}
      
      newClass = Class.new(Chewy::Index) do

        settings analysis: {
            filter: {
              edge_ngram_filter: {
                type: "edge_ngram",
                min_gram: 1,
                max_gram: 10
              }
            },
            analyzer: {
              default: {
                type: "custom",
                tokenizer: "standard",
                filter: [
                  "lowercase",
                  "asciifolding",
                  "edge_ngram_filter"
                ]
              },
              default_search: {
                type: "custom",
                tokenizer: "whitespace",
                filter: [
                  "lowercase",
                  "asciifolding"
                ]
              }
            }
          }
        
        index_scope klass.name
        
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/keyword.html
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/string.html
        string_columns.each do |column|
          #field(column.name.to_sym, type: "keyword")
          field(column.name.to_sym, type: "text")
        end
        
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/text.html
        text_columns.each do |column|
          field(column.name.to_sym, type: "text")
        end
        
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/number.html
        field :identity_id, type: "long"
        field :is_public, type: "boolean"
        
        integer_columns.each do |column|
          field(column.name.to_sym, type: "long")
        end
      end
      
      Object.const_set indexName, newClass
      
      @@indices.push(indexName)
      @@models[indexName] = klass
      @@elasticClasses[indexName] = newClass
    else
      #Rails.logger.debug{"Skipping Elastic index #{indexName}"}
    end
  end

  Rails.logger.debug{"ElasticWrapper indices=#{@@indices.sort.join(", ")}"}

  def self.reset()
    Rails.logger.debug{"ElasticWrapper.reset entry"}
    @@indices.each do |index|
      Chewy.strategy(:atomic) do
        Rails.logger.debug{"ElasticWrapper.reset processing #{index}"}
        model = @@models[index]
        instances = model.all
        Rails.logger.debug{"ElasticWrapper.reset retrieved #{instances.count} instances"}

        elasticClass = @@elasticClasses[index]
        Rails.logger.debug{"ElasticWrapper.reset deleting index"}
        begin
          elasticClass.delete
        rescue Elastic::Transport::Transport::Errors::NotFound
          # Index doesn't exist
        end
        
        Rails.logger.debug{"ElasticWrapper.reset creating index"}
        elasticClass.create

        Rails.logger.debug{"ElasticWrapper.reset importing instances"}
        elasticClass.import instances
      end
    end
    Rails.logger.debug{"ElasticWrapper.reset exit"}
    
    return nil
  end
  
  def self.getElasticClassByModelName(model)
    return @@elasticClasses[model + "Index"]
  end
  
end
