class QuizItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :quiz_question, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :quiz_answer, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :link, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :correct_choice, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
    ]
  end

  belongs_to :quiz
  
  validates :quiz_question, presence: true
  
  validate do
    if !self.quiz.nil? && !self.quiz.choices.blank? && self.correct_choice.blank?
      errors.add(:correct_choice, I18n.t("myplaceonline.general.non_blank"))
    end
  end
  
  child_files
  
  scope :ignored, -> { where(ignore: true) }
  scope :unignored, -> { where("(ignore is null or ignore = ?)", false) }
  
  def display
    Myp.ellipses_if_needed(self.quiz_question, 32)
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
      :correct_choice,
      quiz_item_files_attributes: FilesController.multi_param_names,
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
  
  def parent_context
    self.quiz
  end
end
