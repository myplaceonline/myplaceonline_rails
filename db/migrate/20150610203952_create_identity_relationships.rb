class CreateIdentityRelationships < ActiveRecord::Migration
  def change
    create_table :identity_relationships do |t|
      t.references :contact, index: true
      t.integer :relationship_type
      t.references :identity, index: true
      t.references :ref, index: true

      t.timestamps
    end
  end
end
