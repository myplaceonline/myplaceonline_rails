class CategoryPermission < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  validates :action, presence: true
  validates :subject_class, presence: true
  
  child_property(name: :user)
  child_property(name: :target_identity, model: Identity, required: true)

  def display
    result = user.display
    result = Myp.appendstrwrap(result, Myp.get_select_name(action, Permission::ACTION_TYPES))
    if !Myp.categories(User.current_user)[subject_class.to_sym].nil?
      result = Myp.appendstrwrap(result, category_display)
    end
    result
  end
end
