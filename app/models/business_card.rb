class BusinessCard < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    contact.display
  end
  
  child_property(name: :contact)

  child_properties(name: :business_card_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(business_card_files, [I18n.t("myplaceonline.category.business_cards"), display])
  end
end
