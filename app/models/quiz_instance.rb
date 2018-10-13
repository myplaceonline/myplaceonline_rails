class QuizInstance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :start_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :end_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
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
    Myp.display_datetime(self.start_time, User.current_user)
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :start_time,
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
  
  def correct_answers_percent
    ((self.total_correct_answers.to_f / self.total_questions.to_f) * 100.0).floor
  end
end
