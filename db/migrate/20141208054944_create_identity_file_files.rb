class CreateIdentityFileFiles < ActiveRecord::Migration
  def self.up
    create_table :files do |t|
      t.integer    :identity_file_id
      t.string     :style
      t.binary     :file_contents
    end
  end

  def self.down
    drop_table :files
  end
end
