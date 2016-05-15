class AddOwnerToIdentities < ActiveRecord::Migration
  def change
    Contact.all.each do |x|
      User.current_user = x.identity.user
      contact_identity = x.contact_identity
      if !contact_identity.nil?
        contact_identity.identity = x.identity
        contact_identity.save!
      end
    end
    UserIndex.reset!
  end
end
