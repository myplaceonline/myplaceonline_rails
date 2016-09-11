class RenameColumnsForContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :archived, :datetime
    Contact.where(hide: true).each do |contact|
      MyplaceonlineExecutionContext.do_context(contact) do
        contact.archived = DateTime.now
        contact.save!
      end
    end
    remove_column :contacts, :hide
  end
end
