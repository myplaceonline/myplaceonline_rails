class PopulateOrigCodeColumn < ActiveRecord::Migration[5.2]
  def up
    ApplicationRecord.connection.execute("update users set origcode = used_invite_code")
  end
end
