class AddContactToTherapists < ActiveRecord::Migration
  def change
    add_reference :therapists, :contact, index: true
  end
end
