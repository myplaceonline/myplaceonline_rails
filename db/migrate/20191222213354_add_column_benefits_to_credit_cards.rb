class AddColumnBenefitsToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :benefits, :text
  end
end
