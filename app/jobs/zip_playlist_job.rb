require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'

class ZipPlaylistJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started ZipPlaylistJob"}
    share = args[0]
    
    count = 0
    
    Dir.mktmpdir do |dir|
      
      files = Array.new
      
      share.playlist.playlist_songs.each do |playlist_song|
        Rails.logger.debug{"Song #{playlist_song.inspect}"}
        
        if !playlist_song.song.identity_file.nil?
          count = count + 1
          data = playlist_song.song.identity_file.file.file_contents
          name = playlist_song.song.identity_file.file_file_name
          name = count.to_s.rjust(2, "0") + "-" + name
          
          Rails.logger.debug{"Data #{data.length}, name #{name}"}
          
          f = File.join(dir, name)

          itemarray = Array.new
          itemarray.push(name)
          itemarray.push(f)
          
          files.push(itemarray)
          
          IO.binwrite(f, data)
        end
      end
      
      if count > 0
        tfile = Tempfile.new(["playlist" + share.playlist.id.to_s + "_", ".zip"])
        Rails.logger.debug{"Created temporary zip file #{tfile.path}"}
        Zip::File.open(tfile.path, Zip::File::CREATE) do |zipfile|
          files.each do |filename|
            zipfile.add(filename[0], filename[1])
          end
        end
        
        zipdata = IO.binread(tfile.path)
        
        Rails.logger.debug{"Zip data #{zipdata.length}"}
        
        begin
          User.current_user = share.owner.owner
          
          iff = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.playlists")])
          identity_file = IdentityFile.build({ folder: iff.id })
          identity_file.file_file_name = Pathname.new(tfile).basename
          identity_file.file_file_size = zipdata.length
          identity_file.file_content_type = "application/zip"
          identity_file.file = File.open(tfile.path)
          identity_file.folder = iff
          identity_file.owner = share.owner
          identity_file.save!
          
        ensure
          User.current_user = nil
        end
      end
    end
  end
end
