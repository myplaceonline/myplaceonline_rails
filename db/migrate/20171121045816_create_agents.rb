class CreateAgents < ActiveRecord::Migration[5.1]
  def change
    create_table :agents do |t|
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_reference :agents, :agent_identity, references: :identities, foreign_key: false
    add_foreign_key :agents, :identities, column: :agent_identity_id
  end
end
