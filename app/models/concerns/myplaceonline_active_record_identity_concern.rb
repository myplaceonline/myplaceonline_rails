# http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module MyplaceonlineActiveRecordIdentityConcern
  extend ActiveSupport::Concern
  include MyplaceonlineActiveRecordBaseConcern
  include ModelHelpersConcern
  include AllowExistingConcern

  included do
    # Owner/creator
    belongs_to :identity

    before_validation :identity_record_set

    attr_accessor :is_archived
    boolean_time_transfer :is_archived, :archived

    def identity_record_set
      if self.respond_to?("identity=")
        current_user = User.current_user
        if !current_user.nil?
          identity_target = Permission.current_target_identity
          if !self.identity_id.nil?
            if self.identity_id != identity_target.id
              # TODO could there be a privilege escalation here by always using action: show?
              if !Ability.authorize(identity: identity_target, subject: self, action: :show)
                raise "Unauthorized"
              end
            end
          elsif identity_target.nil?
            if self.id == 0
              # Special case when database is being seeded
            else
              #raise "Identity target is nil"
              # This was here as kind of an assert, but it breaks creating a new user
            end
          else
            self.identity_id = identity_target.id
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
        put_file_in_folder(file, folders)
      end
    end
    
    def put_file_in_folder(file, folders)
      if file.identity_file.folder.nil?
        file.identity_file.folder = IdentityFileFolder.find_or_create(folders)
        file.identity_file.save!
      end
    end
    
    def current_user_owns?
      identity == User.current_user.primary_identity
    end
    
    def owning_user
      identity.user
    end
  end
  
  class_methods do
    
    def myplaceonline_validates_uniqueness_of(field)
      validates field, uniqueness: {
        scope: :identity_id,
        message: ->(object, data) {
          
          Rails.logger.debug{"Found duplicate with field: #{field}, attribute: #{data[:attribute]}, value: #{data[:value]}"}
          
          existing_object = self.where(
            field => data[:value],
            :identity_id => User.current_user.primary_identity_id
          ).take!
          
          I18n.t(
            "myplaceonline.general.dup_item",
            dup_field: I18n.t("myplaceonline." + data[:model].pluralize.downcase + "." + field.to_s),
            link: ActionController::Base.helpers.link_to(
                    existing_object.display,
                    Rails.application.routes.url_helpers.send("#{self.name.downcase}_path", existing_object)
                  )
          )
        }
      }
    end
  end
end
