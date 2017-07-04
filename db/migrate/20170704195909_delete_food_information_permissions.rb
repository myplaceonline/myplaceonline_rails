class DeleteFoodInformationPermissions < ActiveRecord::Migration[5.1]
  def change
    ApplicationRecord.connection.execute("delete from permissions where user_id is null")
  end
end
