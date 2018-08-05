class Quiz < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :quiz_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :quiz_items, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
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
end
