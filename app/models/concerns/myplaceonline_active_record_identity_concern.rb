# http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module MyplaceonlineActiveRecordIdentityConcern
  extend ActiveSupport::Concern
  include MyplaceonlineActiveRecordBaseConcern

  included do
    # Owner/creator
    belongs_to :identity

    before_create :identity_record_before_save
    before_update :identity_record_before_save
    before_save :identity_record_before_save

    def identity_record_before_save
      if self.respond_to?("identity=")
        current_user = User.current_user
        if !current_user.nil?
          identity_target = Permission.current_target_identity
          if !self.identity.nil?
            if self.identity_id != identity_target.id
              raise "Unauthorized"
            end
          else
            self.identity = identity_target
          end
        else
          raise "User.current_user not set"
        end
      else
        raise "identity= not found"
      end
    end
    
    def put_files_in_folder(files, folders)
      files.each do |file|
        if file.identity_file.folder.nil?
          file.identity_file.folder = IdentityFileFolder.find_or_create(folders)
        end
      end
    end
    
    def current_user_owns?
      identity == User.current_user.primary_identity
    end
  end
end
