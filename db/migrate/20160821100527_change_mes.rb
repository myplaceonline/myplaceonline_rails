class ChangeMes < ActiveRecord::Migration
  def change
    User.all.each do |user|
      User.current_user = user
      identity = user.primary_identity
      contact = identity.ensure_contact!
      if identity.name.blank? || identity.name == I18n.t("myplaceonline.contacts.me")
        identity.name = identity.name_from_email
        identity.save!
      end
    end
  end
end
