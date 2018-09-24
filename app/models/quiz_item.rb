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
  
  scope :ignored, -> { where(ignore: true) }
  scope :unignored, -> { where("(ignore is null or ignore = ?)", false) }
  
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
      :ignore,
    ]
  end
  
  def copy_targets
    Quiz.where("identity_id = :identity_id and archived is null", identity_id: self.identity_id)
        .dup.to_a
        .delete_if{|quiz| quiz.id == self.quiz.id}
  end
  
  def copyable?
    targets = self.copy_targets
    
    result = targets.length > 0
    
    targets.each do |target|
      target.quiz_items.each do |target_item|
        if target_item.quiz_question == self.quiz_question
          result = false
        end
      end
    end
    
    result
  end
end
