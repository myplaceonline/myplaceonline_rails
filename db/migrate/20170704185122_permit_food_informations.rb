class PermitFoodInformations < ActiveRecord::Migration[5.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      Permission.create!(
        identity_id: User.super_user.current_identity_id,
        action: Permission::ACTION_READ,
        subject_class: Myp.model_to_category_name(FoodInformation)
      )
    end
  end
end
