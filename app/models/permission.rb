class Permission < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ModelHelpersConcern
  
  ACTION_MANAGE = 1
  ACTION_READ = 2
  ACTION_CREATE = 4
  ACTION_UPDATE = 8
  ACTION_DESTROY = 16

  ACTION_TYPES = [
    ["myplaceonline.permissions.action_manage", ACTION_MANAGE],
    ["myplaceonline.permissions.action_read", ACTION_READ],
    ["myplaceonline.permissions.action_create", ACTION_CREATE],
    ["myplaceonline.permissions.action_update", ACTION_UPDATE],
    ["myplaceonline.permissions.action_destroy", ACTION_DESTROY]
  ]
  
  validates :user, presence: true
  validates :action, presence: true
  validates :subject_class, presence: true
  
  bit_flags_transfer :actionbit, Permission::ACTION_TYPES, :action
  
  def display
    result = user.display
    result = Myp.appendstrwrap(result, Myp.get_select_name(action, Permission::ACTION_TYPES))
    result = Myp.appendstrwrap(result, category_display)
    if !subject_id.nil?
      result = Myp.appendstrwrap(result, subject_id.to_s)
    end
    result
  end
  
  belongs_to :user
  accepts_nested_attributes_for :user, reject_if: :all_blank
  allow_existing :user

  validate do
    if !subject_id.nil? && Myp.find_existing_object(Myp.category_to_model_name(subject_class), subject_id).nil?
      errors.add(:subject_id, I18n.t("myplaceonline.permissions.invalid_id"))
    end
  end
  
  def category_display
    Category.where(name: subject_class).take!.human_title
  end
  
  def path
    if subject_id.nil?
      Rails.application.routes.url_helpers.send(subject_class + "_path")
    else
      Rails.application.routes.url_helpers.send(subject_class.singularize + "_path", subject_id)
    end
  end
  
  def url
    if subject_id.nil?
      Rails.application.routes.url_helpers.send(subject_class + "_url", Rails.configuration.default_url_options)
    else
      Rails.application.routes.url_helpers.send(subject_class.singularize + "_url", subject_id, Rails.configuration.default_url_options)
    end
  end

  def self.current_target
    Thread.current[:current_target]
  end

  def self.current_target=(target)
    Thread.current[:current_target] = target
  end
  
  def self.current_target_owner
    target = Permission.current_target
    if target.nil?
      target_owner = User.current_user.primary_identity
    else
      target_owner = target.owner
    end
  end
  
  def self.permission_params(subject_class, subject_id, permissions = [Permission::ACTION_READ, Permission::ACTION_UPDATE])
    result = {
      permission: {
        subject_class: subject_class,
        subject_id: subject_id
      }
    }
    
    permissions.each do |permission|
      result[:permission]["actionbit#{permission}"] = "1"
    end

    result
  end
end
