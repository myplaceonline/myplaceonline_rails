class AddColumnCorrectChoiceToQuizItems < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_items, :correct_choice, :integer
  end
end
