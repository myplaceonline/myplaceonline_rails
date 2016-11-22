class BusinessCard < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    contact.display
  end
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :contact

  has_many :business_card_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :business_card_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :business_card_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(business_card_files, [I18n.t("myplaceonline.category.business_cards"), display])
  end
end
