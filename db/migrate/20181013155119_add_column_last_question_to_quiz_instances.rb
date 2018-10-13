class AddColumnLastQuestionToQuizInstances < ActiveRecord::Migration[5.1]
  def change
    add_reference :quiz_instances, :last_question, index: true, foreign_key: false
    add_foreign_key :quiz_instances, :quiz_items, column: :last_question_id
  end
end
