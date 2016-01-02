# http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module MyplaceonlineActiveRecordIdentityConcern
  extend ActiveSupport::Concern
  include MyplaceonlineActiveRecordBaseConcern

  included do
    belongs_to :owner, class_name: Identity

    before_create :identity_record_before_save
    before_update :identity_record_before_save

    def identity_record_before_save
      if self.respond_to?("owner=")
        current_user = User.current_user
        if !current_user.nil?
          owner_target = Permission.current_target_owner
          if !self.owner.nil?
            if self.owner_id != owner_target.id
              raise "Unauthorized"
            end
          else
            self.owner = owner_target
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
    
    def current_user_owns?
      owner == User.current_user.primary_identity
    end
  end
end
