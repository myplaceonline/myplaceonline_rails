class SetContactsIcon < ActiveRecord::Migration
  def change
    Myp.migration_set_icon("contacts", "famfamfam/user.png")
  end
end
