class IdentityFileFolder < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :folder_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end
  
  child_property(name: :parent_folder, model: IdentityFileFolder)

  validates :folder_name, presence: true

  def display
    folder_name
  end
  
  has_many :identity_files, :dependent => :destroy, :foreign_key => "folder_id"
  
  def subfolders
    IdentityFileFolder.where(
      identity_id: User.current_user.current_identity_id,
      parent_folder: self.id
    ).order(FileFoldersController.sorts)
  end

  def self.find_or_create(names, parent = nil)
    names = names.reverse
    while names.length > 0
      name = names.pop
      if parent.nil?
        folders = IdentityFileFolder.where(
          identity_id: User.current_user.current_identity_id,
          folder_name: name
        )
        if folders.length == 0
          parent = IdentityFileFolder.new(folder_name: name, identity_id: User.current_user.current_identity_id)
          # This save seems to be needed for deep structures even though we have implicit autosave
          parent.save!
        elsif folders.length == 1
          parent = folders[0]
        else
          parent = folders[0]
          Myp.warn("Multiple folders somehow: name: #{name}, identity: #{User.current_user.current_identity_id}")
        end
      else
        folders = IdentityFileFolder.where(
          identity_id: User.current_user.current_identity_id,
          folder_name: name,
          parent_folder_id: parent.id
        )
        if folders.length == 0
          parent = IdentityFileFolder.new(folder_name: name, identity_id: User.current_user.current_identity_id, parent_folder_id: parent.id)
          # This save seems to be needed for deep structures even though we have implicit autosave
          parent.save!
        elsif folders.length == 1
          parent = folders[0]
        else
          parent = folders[0]
          Myp.warn("Multiple folders somehow: name: #{name}, identity: #{User.current_user.current_identity_id}")
        end
      end
    end
    parent
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    if !params[:parent].nil?
      folders = IdentityFileFolder.where(
        identity_id: User.current_user.current_identity_id,
        id: params[:parent].to_i
      )
      if folders.size > 0
        result.parent_folder = folders.first
      end
    end
    result
  end
  
  def show?
    result = true
    if MyplaceonlineExecutionContext.offline?
      check_name = self.display
      if check_name == "Exports"
        result = false
      end
    end
    result
  end
end
