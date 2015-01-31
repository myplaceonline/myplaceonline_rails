class AddEncryptionToCreditCards < ActiveRecord::Migration
  def change
    add_reference :credit_cards, :number_encrypted, index: true
    add_reference :credit_cards, :security_code_encrypted, index: true
    add_reference :credit_cards, :pin_encrypted, index: true
    add_reference :credit_cards, :expires_encrypted, index: true
  end
end
