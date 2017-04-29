class ResetBirthdayReminders < ActiveRecord::Migration[5.0]
  def change
    Identity.all.each do |x|
      if !x.contact.nil?
        MyplaceonlineExecutionContext.do_user(x.contact.identity.user) do
          x.on_after_save
        end
      end
    end
  end
end
