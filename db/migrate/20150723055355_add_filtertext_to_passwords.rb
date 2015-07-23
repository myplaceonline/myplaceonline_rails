class AddFiltertextToPasswords < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("passwords", "websites")
  end
end
