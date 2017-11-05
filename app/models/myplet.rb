# x_coordinate:integer y_coordinate:integer title:string category_name:string category_id:integer border_type:integer collapsed:boolean
class Myplet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  
  BORDER_TYPE_NONE = 0
  BORDER_TYPE_TITLE = 1

  BORDER_TYPES = [
    ["myplaceonline.border_types.none", BORDER_TYPE_NONE],
    ["myplaceonline.border_types.title", BORDER_TYPE_TITLE]
  ]

  def display
    Myp.evaluate_if_probably_i18n(title)
  end
  
  validate do
    # Make sure the user has access to this object
    if !category_name.blank? && !category_id.nil?
      cls = Object.const_get(category_name.camelize.singularize)
      if cls.where(id: category_id, identity: User.current_user.current_identity).count == 0
        errors.add(:category_id, I18n.t("myplaceonline.general.not_auhorized"))
      end
    end
  end

  def self.default_myplets(identity)
    result = Array.new
    
    ActiveRecord::Base.transaction do
      
      identity.website_domain.website_domain_myplets.each do |myplet|
        model_attributes = {}
        myplet.website_domain_myplet_parameters.each do |myplet_param|
          param_value = myplet_param.val
          if Myp.is_probably_i18n(param_value)
            param_value = I18n.t(param_value)
          end
          model_attributes[myplet_param.name] = param_value
        end
        
        new_myplet = myplet.category.model.create!(model_attributes)
        
        result.push(Myplet.create!({
          title: myplet.title,
          y_coordinate: myplet.position,
          x_coordinate: 0,
          category_name: myplet.category.name,
          category_id: new_myplet.id,
          border_type: myplet.border_type,
          identity: identity,
        }))
      end
      
    end

    result
  end
  
  def show_highly_visited?
    false
  end
  
  def link
    result = "/#{self.category_name}"
    if !self.category_id.nil?
      result += "/#{self.category_id}"
    end
    result
  end
end
