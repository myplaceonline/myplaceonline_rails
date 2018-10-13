class AddColumnChoicesToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :choices, :integer
  end
end
