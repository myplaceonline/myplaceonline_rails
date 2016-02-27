class ConvertContactNames < ActiveRecord::Migration
  def change
    Contact.all.each do |x|
      User.current_user = x.identity.user
      if !x.contact_identity.nil? && !x.contact_identity.name.blank?
        splits = x.contact_identity.name.split(" ")
        if splits.length > 1
          x.contact_identity.name = splits[0]
          x.contact_identity.last_name = splits[splits.length-1]
          if splits.length > 2
            splits.delete_at(0)
            splits.delete_at(splits.length - 1)
            x.contact_identity.middle_name = splits.join(" ")
          end
          x.contact_identity.save!
        end
      end
    end
  end
end
