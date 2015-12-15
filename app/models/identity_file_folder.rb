class IdentityFileFolder < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_folder, class_name: IdentityFileFolder
  accepts_nested_attributes_for :parent_folder
  allow_existing :parent_folder, IdentityFileFolder

  validates :folder_name, presence: true

  def display
    folder_name
  end
  
  has_many :identity_files, :dependent => :destroy, :foreign_key => "folder_id"
  
  def subfolders
    IdentityFileFolder.where(
      owner_id: User.current_user.primary_identity.id,
      parent_folder: self.id
    ).order(FileFoldersController.sorts)
  end

  def self.find_or_create(names, parent = nil)
    names = names.reverse
    while names.length > 0
      name = names.pop
      if parent.nil?
        folders = IdentityFileFolder.where(
          owner_id: User.current_user.primary_identity.id,
          folder_name: name
        )
        if folders.length == 0
          parent = IdentityFileFolder.new(folder_name: name, owner_id: User.current_user.primary_identity.id)
          # This save seems to be needed for deep structures even though we have implicit autosave
          parent.save!
        elsif folders.length == 1
          parent = folders[0]
        else
          raise "TODO"
        end
      else
        folders = IdentityFileFolder.where(
          owner_id: User.current_user.primary_identity.id,
          folder_name: name,
          parent_folder_id: parent.id
        )
        if folders.length == 0
          parent = IdentityFileFolder.new(folder_name: name, owner_id: User.current_user.primary_identity.id, parent_folder_id: parent.id)
          # This save seems to be needed for deep structures even though we have implicit autosave
          parent.save!
        elsif folders.length == 1
          parent = folders[0]
        else
          raise "TODO"
        end
      end
    end
    parent
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    if !params[:parent].nil?
      folders = IdentityFileFolder.where(
        owner_id: User.current_user.primary_identity.id,
        id: params[:parent].to_i
      )
      if folders.size > 0
        result.parent_folder = folders.first
      end
    end
    result
  end
end
