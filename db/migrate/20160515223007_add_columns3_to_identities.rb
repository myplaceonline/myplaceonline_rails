class AddColumns3ToIdentities < ActiveRecord::Migration
  def change
    add_reference :identities, :identity, index: true, foreign_key: true
  end
end
