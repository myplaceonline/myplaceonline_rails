class QuizItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :quiz_question, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :quiz_answer, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :link, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :quiz
  
  validates :quiz_question, presence: true
  validates :quiz_answer, presence: true
  
  def display
    self.quiz_question
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :quiz_question,
      :quiz_answer,
      :link,
      :notes,
    ]
  end
end
