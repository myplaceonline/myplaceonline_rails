class ConvertTherapistDetailsToContact < ActiveRecord::Migration
  def change
    Therapist.all.each do |t|

      User.current_user = t.owner.owner

      c = Contact.new
      i = Identity.new

      i.name = t.name
      i.notes = t.notes

      t.therapist_conversations.each do |tc|
        cc = Conversation.new
        cc.conversation_date = tc.conversation_date
        cc.conversation = tc.conversation
        c.conversations << cc
      end

      t.therapist_emails.each do |te|
        ie = IdentityEmail.new
        ie.email = te.email
        i.identity_emails << ie
      end

      t.therapist_locations.each do |tl|
        il = IdentityLocation.new
        il.location = tl.location
        i.identity_locations << il
      end

      t.therapist_phones.each do |tp|
        ip = IdentityPhone.new
        ip.number = tp.number
        ip.phone_type = tp.phone_type
        i.identity_phones << ip
      end

      c.identity = i
      t.contact = c

      t.save!
    end
  end
end
