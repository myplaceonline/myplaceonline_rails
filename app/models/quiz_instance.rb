class QuizInstance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :start_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :end_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :orderby, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
    ]
  end

  ORDERBY_CREATION_DATE = 0

  ORDERBY = [
    ["myplaceonline.quiz_instances.orderbys.creation_date", ORDERBY_CREATION_DATE],
  ]

  belongs_to :quiz
  
  validates :start_time, presence: true
  
  child_property(name: :last_question, model: QuizItem)
  
  def display
    result = self.description.blank? ? Myp.display_datetime(self.start_time, User.current_user) : self.description
    if self.is_finished?
      result = Myp.appendstrwrap(result, "#{self.correct_answers_percent}%")
    end
    result
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :start_time,
      :description,
      :end_time,
      :orderby,
      :notes,
    ]
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.start_time = User.current_user.time_now
    result
  end
  
  def total_correct_answers
    total_correct = self.correct
    if total_correct.nil?
      total_correct = 0
    end
    total_correct
  end
  
  def total_questions
    self.quiz.quiz_items.count
  end
  
  def total_incorrect_answers
    self.total_questions - self.total_correct_answers
  end
  
  def correct_answers_percent
    result = ((self.total_correct_answers.to_f / self.total_questions.to_f) * 100.0).floor
    if result > 100
      # If questions get deleted
      result = 100
    end
    result
  end
  
  def is_finished?
    !self.end_time.nil?
  end
end
