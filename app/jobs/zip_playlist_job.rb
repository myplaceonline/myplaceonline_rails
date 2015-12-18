require 'tmpdir'
require 'rubygems'
require 'zip'
require 'tempfile'

class ZipPlaylistJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started ZipPlaylistJob"}
    share = args[0]
    
    count = 0
    
    Dir.mktmpdir do |dir|
      
      files = Array.new
      song_identity_files = Array.new
      
      share.playlist.playlist_songs.each do |playlist_song|
        Rails.logger.debug{"Song #{playlist_song.inspect}"}
        
        if !playlist_song.song.identity_file.nil?
          count = count + 1
          data = playlist_song.song.identity_file.file.file_contents
          name = playlist_song.song.identity_file.file_file_name
          name = count.to_s.rjust(2, "0") + " - " + name
          
          Rails.logger.debug{"Data #{data.length}, name #{name}"}
          
          f = File.join(dir, name)

          itemarray = Array.new
          itemarray.push(name)
          itemarray.push(f)
          
          files.push(itemarray)
          
          song_identity_files.push(playlist_song.song.identity_file)
          
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
          
          ActiveRecord::Base.transaction do
            # We'll create a share with a unique token that we'll
            # use for the playlist share, each song's identity file and
            # the identity file for the whole zip
            public_share = Share.new
            public_share.owner = share.owner
            public_share.token = SecureRandom.hex(10)
            public_share.save!
            
            Rails.logger.debug{"Created share #{public_share.inspect}"}
            
            iff = IdentityFileFolder.find_or_create([I18n.t("myplaceonline.category.playlists")])
            identity_file = IdentityFile.build({ folder: iff.id })
            identity_file.file_file_name = Pathname.new(tfile).basename
            identity_file.file_file_size = zipdata.length
            identity_file.file_content_type = "application/zip"
            identity_file.file = File.open(tfile.path)
            identity_file.folder = iff
            identity_file.owner = share.owner
            identity_file.save!
            
            Rails.logger.debug{"Created identity file #{identity_file.inspect}"}

            ifs = IdentityFileShare.new
            ifs.owner = share.owner
            ifs.identity_file = identity_file
            ifs.share = public_share
            ifs.save!

            Rails.logger.debug{"Created identity file share for zip #{ifs.inspect}"}
            
            share.playlist.identity_file = identity_file
            share.playlist.save!
            
            share.share = public_share
            share.save!
            
            Rails.logger.debug{"Updated playlist zip file and share for share #{share.inspect}"}

            song_identity_files.each do |song_identity_file|
              ifs = IdentityFileShare.new
              ifs.owner = song_identity_file.owner
              ifs.identity_file = song_identity_file
              ifs.share = public_share
              ifs.save!
              Rails.logger.debug{"Created identity file share for song #{ifs.inspect}"}
            end
            
            content = "<p>" + ERB::Util.html_escape_once(share.body) + "</p>"
            url = playlists_shared_url(share.playlist, token: public_share.token)
            content += "<p>" + ActionController::Base.helpers.link_to(url, url) + "</p>"
            
            # Once we have the ZIP, now we can send out the email
            cc = nil
            if share.copy_self
              cc = User.current_user.email
            end
            to = Array.new
            share.playlist_share_contacts.each do |playlist_share_contact|
              playlist_share_contact.contact.identity.emails.each do |identity_email|
                to.push(identity_email)
              end
            end
            Myp.send_email(to, share.subject, content.html_safe, cc)
          end
          
        ensure
          User.current_user = nil
        end
      end
    end
  end
end
