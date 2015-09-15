class MoveMainNotepadToMyplets < ActiveRecord::Migration
  def change
    Myplet.where(category_name: "notepads").each do |myplet|
      if !myplet.owner.notepad.blank?
        User.current_user = myplet.owner.owner
        notepad = Notepad.where(id: myplet.category_id).first
        notepad.notepad_data = myplet.owner.notepad
        notepad.save!
        myplet.owner.notepad = nil
        myplet.owner.save!
      end
    end
  end
end
