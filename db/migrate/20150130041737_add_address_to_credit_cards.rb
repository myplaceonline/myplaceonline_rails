class AddAddressToCreditCards < ActiveRecord::Migration
  def change
    add_reference :credit_cards, :address, index: true
  end
end
