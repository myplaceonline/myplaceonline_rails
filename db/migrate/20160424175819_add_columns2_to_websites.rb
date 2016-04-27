class AddColumns2ToWebsites < ActiveRecord::Migration
  def change
    add_reference :websites, :recommender, index: true, foreign_key: false
    add_foreign_key :websites, :contacts, column: :recommender_id
  end
end
