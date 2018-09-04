class Quiz < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :quiz_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :quiz_items, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :autolink, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :autogenerate_context, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  child_properties(name: :quiz_items, sort: "created_at ASC")

  validates :quiz_name, presence: true
  
  def display
    quiz_name
  end
  
  def next_random_question(previous_question: nil)
    result = self.quiz_items[rand(self.quiz_items.count)]
    if !previous_question.nil? && result == previous_question
      result = self.quiz_items[rand(self.quiz_items.count)]
    end
    result
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_most_visited_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.most_visited")
  end

  def self.category_split_button_icon
    "star"
  end
  
  def autogenerate
    html = Myp.http_get(url: self.autolink)
    
    # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/HTML/Document
    doc = Nokogiri::HTML(html[:body]) do |config|
      # https://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html
      config.huge.noerror.noblanks.noent
    end
    
    if !self.autogenerate_context.blank?
      newdoc = Nokogiri::HTML::Document.parse("<html />")
      root = newdoc.root
      subset = doc.xpath(self.autogenerate_context)
      if subset.count > 0
        subset = subset[0]
        root << subset.dup
        sibling = subset.next_sibling
        while !sibling.nil?
          if sibling.name == subset.name
            break
          end
          root << sibling.dup
          sibling = sibling.next_sibling
        end
        doc = newdoc
      end
    end
    
    # https://www.nokogiri.org/tutorials/searching_a_xml_html_document.html
    links = doc.xpath("//a")
    
    ActiveRecord::Base.transaction do
      self.quiz_items.destroy_all
      
      # https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Element
      links.each do |link|
        
        Rails.logger.debug{"Processing #{link}"}
        
        context_link = nil
        answer = link.inner_html
        
        parent = link.parent
        while !parent.nil?
          if parent.name == "p" || parent.name == "li" || parent.name == "div"
            answer = parent.inner_html
            
            if parent.name == "li"
              parent = parent.parent
              while !parent.nil?
                if (parent.name == "ol" || parent.name == "ul") && parent.parent.name != "li"
                  break
                elsif parent.parent.document?
                  break
                end
                parent = parent.parent
              end
            end
            
            sibling = parent.previous_sibling
            while !sibling.nil?
              if sibling.name.start_with?("h")
                h_id = sibling["id"]
                if !h_id.blank?
                  context_link = self.autolink + "#" + h_id
                  break
                end
              end
              sibling = sibling.previous_sibling
            end
            break
          end
          parent = parent.parent
        end
        
        self.quiz_items << QuizItem.new(
          identity_id: User.current_user.domain_identity,
          quiz: self,
          quiz_question: I18n.t("myplaceonline.quizzes.autogenerate_question", question: link.inner_html.titleize),
          quiz_answer: Myp.html_to_markdown(answer),
          link: context_link,
          notes: nil,
        )
      end
      
      self.save!
    end
  end
end
