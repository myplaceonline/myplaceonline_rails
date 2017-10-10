class Playlist < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :playlist_name, presence: true
  
  child_properties(name: :playlist_songs, sort: "position ASC")
  
  has_many :playlist_shares

  # zip file of all songs
  belongs_to :identity_file

  def display
    playlist_name
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
    
    Myp.mktmpdir do |dir|
      
      files = Array.new
      identity_files = Array.new
      
      obj.playlist_songs.each do |playlist_song|
        if !playlist_song.song.identity_file.nil?
          count = count + 1
          data = playlist_song.song.identity_file.get_file_contents
          name = playlist_song.song.identity_file.file_file_name
          name = count.to_s.rjust(2, "0") + " - " + name
          
          f = File.join(dir, name)

          itemarray = Array.new
          itemarray.push(name)
          itemarray.push(f)
          
          files.push(itemarray)
          
          identity_files.push(playlist_song.song.identity_file)
          
          IO.binwrite(f, data)
        end
      end
      
      if count > 0
        Myp.tmpfile("playlist" + obj.id.to_s + "_", ".zip") do |tfile|
          Zip::File.open(tfile.path, Zip::File::CREATE) do |zipfile|
            files.each do |filename|
              zipfile.add(filename[0], filename[1])
            end
          end
          
          zipdata = IO.binread(tfile.path)
          
          MyplaceonlineExecutionContext.do_full_context(obj.identity.user) do
            ApplicationRecord.transaction do
              iff = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.playlists")])
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
              
              permission_share.send_email
            end
          end
        end
      end
    end
  end
end
