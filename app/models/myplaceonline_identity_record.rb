class MyplaceonlineIdentityRecord < MyplaceonlineModelBase
  self.abstract_class = true
  
  belongs_to :owner, class_name: Identity

  before_create :identity_record_before_save
  before_update :identity_record_before_save

  def identity_record_before_save
    if self.respond_to?("owner=")
      current_user = User.current_user
      if !current_user.nil?
        if !self.owner.nil?
          if self.owner_id != current_user.primary_identity.id
            raise "Unauthorized"
          end
        else
          self.owner = current_user.primary_identity
        end
      else
        raise "User.current_user not set"
      end
    else
      raise "owner= not found"
    end
  end
  
  def put_pictures_in_folder(pictures, folders)
    pictures.each do |pic|
      if pic.identity_file.folder.nil?
        pic.identity_file.folder = IdentityFileFolder.find_or_create(folders)
      end
    end
  end
  
  def self.build(params = nil)
    new(params)
  end
end
