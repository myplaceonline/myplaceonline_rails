class AddColumnAutogenerateContextToQuizzes < ActiveRecord::Migration[5.1]
  def change
    add_column :quizzes, :autogenerate_context, :string
  end
end
