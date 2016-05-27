class Trip < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :location, presence: true
  validates :started, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  belongs_to :hotel
  accepts_nested_attributes_for :hotel, reject_if: proc { |attributes| HotelsController.reject_if_blank(attributes) }
  allow_existing :hotel

  has_many :trip_pictures, :dependent => :destroy
  accepts_nested_attributes_for :trip_pictures, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :trip_pictures, [{:name => :identity_file}]
  
  has_many :trip_stories, :dependent => :destroy
  accepts_nested_attributes_for :trip_stories, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :trip_stories, [{:name => :story}]
  
  belongs_to :identity_file

  before_validation :update_pic_folders
  
  def update_pic_folders
    folders = Array.new
    folders.push(I18n.t("myplaceonline.category.trips"))
    if !self.location.nil? && !self.location.region_name.blank?
      folders.push(self.location.region_name)
    end
    if !self.location.nil? && !self.location.sub_region1_name.blank?
      folders.push(self.location.sub_region1_name)
    end
    if !self.location.nil? && !self.location.sub_region2.blank?
      folders.push(self.location.sub_region2)
    end
    if folders.length == 1
      if !self.location.nil? && !self.location.display_general_region.blank?
        folders.push(self.location.display_general_region)
      end
    end
    put_files_in_folder(trip_pictures, folders)
  end
  
  def display
    if ended.nil?
      result = Myp.display_date_short_year(started, User.current_user)
    else
      result = Myp.display_date_short(started, User.current_user)
    end
    if !ended.nil?
      result += " - " + Myp.display_date_short_year(ended, User.current_user)
    end
    result += " (" + location.display_simple + ")"
    if work
      result += " (" + I18n.t("myplaceonline.trips.work") + ")"
    end
    result
  end
  
  def self.has_shared_page?
    true
  end
  
  def self.share_async?(permission_share)
    true
  end
  
  def self.execute_share(permission_share)
    
    obj = Myp.find_existing_object!(permission_share.subject_class, permission_share.subject_id)

    count = 0
    
    include_pics = permission_share.child_selections_list
    source_list = obj.trip_pictures.to_a.dup.keep_if{|x| !include_pics.index(x.id).nil? }
    
    Myp.mktmpdir do |dir|
      
      files = Array.new
      identity_files = Array.new
      
      source_list.each do |trip_picture|
        if !trip_picture.identity_file.nil?
          count = count + 1
          data = trip_picture.identity_file.get_file_contents
          name = trip_picture.identity_file.file_file_name
          
          f = File.join(dir, name)

          itemarray = Array.new
          itemarray.push(name)
          itemarray.push(f)
          
          files.push(itemarray)
          
          identity_files.push(trip_picture.identity_file)
          
          IO.binwrite(f, data)
        end
      end
      
      Rails.logger.info{"Trip execute_share. count: #{count}, obj: #{obj.inspect}"}

      if count > 0
        Myp.tmpfile("trip" + obj.id.to_s + "_", ".zip") do |tfile|
          Zip::File.open(tfile.path, Zip::File::CREATE) do |zipfile|
            files.each do |filename|
              zipfile.add(filename[0], filename[1])
            end
          end
          
          zipdata = IO.binread(tfile.path)
          
          begin
            User.current_user = obj.identity.user
            
            ActiveRecord::Base.transaction do
              iff = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.trips")])
              identity_file = IdentityFile.build({ folder: iff.id })
              identity_file.file_file_name = Pathname.new(tfile).basename
              identity_file.file_file_size = zipdata.length
              identity_file.file_content_type = "application/zip"
              if zipdata.length > IdentityFile::SIZE_THRESHOLD_FILESYSTEM
                dest = Pathname.new(Rails.configuration.filetmpdir).join(File.basename(tfile.path))
                FileUtils.cp(tfile.path, dest)
                FileUtils.chmod(0755, dest)
                identity_file.filesystem_path = dest
              else
                identity_file.file = File.open(tfile.path)
              end
              identity_file.folder = iff
              identity_file.identity = obj.identity
              identity_file.save!
              
              obj.identity_file = identity_file
              obj.save!
              
              psc = PermissionShareChild.new
              psc.identity = obj.identity
              psc.share = permission_share.share
              psc.subject_class = IdentityFile.name
              psc.subject_id = identity_file.id
              psc.permission_share = permission_share
              psc.save!

              identity_files.each do |identity_file|
                psc = PermissionShareChild.new
                psc.identity = obj.identity
                psc.share = permission_share.share
                psc.subject_class = IdentityFile.name
                psc.subject_id = identity_file.id
                psc.permission_share = permission_share
                psc.save!
              end
              
              permission_share.send_email(obj)
            end
          ensure
            User.current_user = nil
          end
        end
      end
    end
  end
  
  def add_email_html(target_email, target_contact, permission_share)
    result = ""
    trip_pictures.each do |trip_picture|
      if !permission_share.permission_share_children.index{|psc| psc.subject_id == trip_picture.identity_file.id}.nil?
        result += "\n<hr />\n  <p>#{ActionController::Base.helpers.link_to file_view_url(
            trip_picture.identity_file, token: permission_share.share.token
          ) do
            ActionController::Base.helpers.image_tag(
              file_thumbnail_url(
                trip_picture.identity_file, token: permission_share.share.token
              )
            )
          end
        }</p>"
        if !trip_picture.identity_file.notes.blank?
          result += "\n#{Myp.markdown_to_html(trip_picture.identity_file.notes)}"
        end
      end
    end
    if trip_stories.count > 0
      result += "\n<hr />\n<p>Stories:</p>\n<ul>\n"
      trip_stories.each do |trip_story|
        result += "  <li>#{trip_story.story.story_name}\n"
        if !trip_story.story.story.blank?
          result += "    #{Myp.markdown_to_html(trip_story.story.story)}\n"
        end
        result += "  </li>\n"
      end
      result += "</ul>\n"
    end
    result
  end

  def add_email_plain(target_email, target_contact, permission_share)
    result = ""
    if trip_pictures.count > 0
      result += "Pictures:\n=========\n"
      trip_pictures.each do |trip_picture|
        if !permission_share.permission_share_children.index{|psc| psc.subject_id == trip_picture.identity_file.id}.nil?
          result += "* " + file_thumbnail_url(
            trip_picture.identity_file, token: permission_share.share.token
          ) + "\n"
          if !trip_picture.identity_file.notes.blank?
            result += "   #{trip_picture.identity_file.notes}\n"
          end
        end
      end
      result += "\n"
    end
    if trip_stories.count > 0
      result += "Stories:\n========\n"
      trip_stories.each do |trip_story|
        result += "* #{trip_story.story.story_name}\n"
        if !trip_story.story.story.blank?
          result += "   #{trip_story.story.story}\n"
        end
      end
    end
    result
  end
  
  after_commit :on_after_create, on: [:create]
  after_commit :on_after_update, on: [:update]
  
  def on_after_create
    Rails.logger.debug{"Trip on_after_create"}
    send_to_emergency_contacts(true)
  end
  
  def on_after_update
    send_to_emergency_contacts(false)
  end
  
  def send_to_emergency_contacts(is_new)
    if notify_emergency_contacts
      identity.emergency_contacts.each do |emergency_contact|
        Rails.logger.debug{"Emergency contact #{emergency_contact.inspect}"}
        emergency_contact.send_contact(
          is_new,
          self,
          I18n.t("myplaceonline.trips.emergency_contact_email",
            {
              contact: identity.display_short,
              location: location.display(use_full_region_name: true),
              start_date: Myp.display_date_short_year(started, User.current_user),
              end_date: ended.nil? ? I18n.t("myplaceonline.general.unknown") : Myp.display_date_short_year(ended, User.current_user),
              map: location.map_url,
              verb: is_new ? I18n.t("myplaceonline.trips.emergency_contact_email_new") : I18n.t("myplaceonline.trips.emergency_contact_email_updated")
            }
          )
        )
      end
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    if User.current_user.has_emergency_contacts?
      result.notify_emergency_contacts = true
    end
    result
  end
  
  def emergency_contact_create_verb
    "myplaceonline.emergency_contacts.verb_planned"
  end

  protected
  def default_url_options
    Rails.configuration.default_url_options
  end
end
