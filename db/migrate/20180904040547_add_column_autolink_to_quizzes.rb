class AddColumnAutolinkToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :autolink, :string
  end
end
