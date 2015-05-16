class IdentityFileFolder < ActiveRecord::Base
  belongs_to :identity
  
  belongs_to :parent_folder, class_name: IdentityFileFolder
  accepts_nested_attributes_for :parent_folder

  # http://stackoverflow.com/a/12064875/4135310
  def parent_folder_attributes=(attributes)
    if !attributes['id'].blank?
      self.parent_folder = IdentityFileFolder.find(attributes['id'])
    end
    super
  end

  validates :folder_name, presence: true

  def display
    folder_name
  end
  
  def subfolders
    IdentityFileFolder.where(
      identity_id: User.current_user.primary_identity.id,
      parent_folder: self.id
    ).order(FileFoldersController.sorts)
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
