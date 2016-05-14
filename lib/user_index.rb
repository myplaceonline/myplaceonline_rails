class UserIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      title: {
        tokenizer: 'standard',
        filter: ['lowercase', 'asciifolding']
      }
    }
  }
  
  Dir[Rails.root.join("app/models/*.rb").to_s].each do |filename|
    klass = File.basename(filename, ".rb").camelize.constantize
    next unless klass.ancestors.include?(ActiveRecord::Base)
    
    # Only process classes that are tied to an identity
    if klass.include?(MyplaceonlineActiveRecordIdentityConcern)
      string_columns = []
      klass.columns.each do |column|
        if column.type == :string || column.type == :text
          if klass.instance_methods.index("#{column.name}_encrypted?".to_sym).nil?
            string_columns.push(column)
          end
        elsif column.type != :integer && column.type != :datetime && column.type != :date && column.type != :boolean && column.type != :decimal && column.type != :binary && column.type != :inet
          # TODO enforce https://www.elastic.co/blog/great-mapping-refactoring
        end
      end
      
      # Only create a type if it has some text fields
      if string_columns.length > 0
        
        #puts "Type: #{klass.name}"
        
        define_type klass do

          # https://www.elastic.co/guide/en/elasticsearch/reference/current/string.html
          #field :allstrings
          
          string_columns.each do |column|
            #puts "  Field: #{column.name}"
            field column.name.to_sym
          end
          
          # https://www.elastic.co/guide/en/elasticsearch/reference/current/number.html
          field :identity_id, type: "integer"
        end
      end
    end
  end
end
