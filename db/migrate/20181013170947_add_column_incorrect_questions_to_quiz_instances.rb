class AddColumnIncorrectQuestionsToQuizInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_instances, :incorrect_questions, :string
  end
end
