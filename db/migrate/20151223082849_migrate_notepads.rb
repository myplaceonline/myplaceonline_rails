class MigrateNotepads < ActiveRecord::Migration
  def change
    Notepad.all.each do |notepad|
      if !notepad.notepad_data.blank?
        User.current_user = notepad.owner.owner
        notepad.notepad_data = notepad.notepad_data.gsub("<li>", "* ").gsub("</li>", "\n").gsub("<br>", "\n\n").gsub("</div>", "\n\n").gsub(/<[^>]+>/, "")
        notepad.save!
      end
    end
  end
end
