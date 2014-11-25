class AddAttachmentFileToIdentityFiles < ActiveRecord::Migration
  def self.up
    change_table :identity_files do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :identity_files, :file
  end
end
