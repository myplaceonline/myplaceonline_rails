class ConvertPlaylistShares < ActiveRecord::Migration
  def change
    PlaylistShare.all.each do |playlist_share|
      User.current_user = playlist_share.identity.user

      ps = PermissionShare.new
      ps.subject = playlist_share.subject
      ps.subject_class = Playlist.name
      ps.subject_id = playlist_share.playlist_id
      ps.body = playlist_share.body
      ps.email = playlist_share.email
      ps.copy_self = playlist_share.copy_self
      ps.share_id = playlist_share.share_id
      ps.identity = playlist_share.identity

      playlist_share.playlist_share_contacts.each do |contact|
        new_contact = PermissionShareContact.new
        new_contact.contact_id = contact.contact_id
        new_contact.identity = playlist_share.identity
        ps.permission_share_contacts << new_contact
      end

      if ps.save
        IdentityFileShare.where(share_id: ps.share_id).each do |x|
          psc = PermissionShareChild.new
          psc.identity = x.identity
          psc.share = x.share
          psc.subject_class = IdentityFile.name
          psc.subject_id = x.identity_id
          psc.permission_share = ps
          psc.save!
        end
      end
    end

    drop_table :playlist_share_contacts
    drop_table :identity_file_shares
    drop_table :playlist_shares
  end
end
