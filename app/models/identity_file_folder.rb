class IdentityFileFolder < ActiveRecord::Base
  belongs_to :identity
  
  belongs_to :parent_folder, class_name: IdentityFileFolder

  def display
    folder_name
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
