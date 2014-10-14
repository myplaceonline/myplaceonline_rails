class PrimaryIdentityReference < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.belongs_to :primary_identity
    end
  end
end
