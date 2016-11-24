# http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module MyplaceonlineActiveRecordIdentityConcern
  extend ActiveSupport::Concern
  include MyplaceonlineActiveRecordBaseConcern
  include ModelHelpersConcern

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
              raise "Unauthorized"
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
      end
    end
    
    def current_user_owns?
      identity == User.current_user.primary_identity
    end
  end
  
  module ClassMethods
    protected
      def myplaceonline_validates_uniqueness_of(field)
        validates field, uniqueness: {
          scope: :identity_id,
          message: ->(object, data) {
            existing_object = self.where(
              data[:attribute].to_s.downcase.to_sym => data[:value],
              :identity_id => User.current_user.primary_identity_id
            ).take!
            I18n.t(
              "myplaceonline.general.dup_item",
              dup_field: I18n.t("myplaceonline." + data[:model].pluralize.downcase + "." + data[:attribute].to_s.downcase),
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
