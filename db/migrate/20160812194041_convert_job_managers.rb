class ConvertJobManagers < ActiveRecord::Migration
  def change
    Job.all.each do |x|
      User.current_user = x.identity.user
      if !x.manager_contact.nil?
        x.job_managers << JobManager.new(contact: x.manager_contact)
        x.manager_contact = nil
        x.save!
      end
    end
  end
end
