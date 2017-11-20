class WebsiteDomainMyplet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_domain

  child_property(name: :category)
  
  child_properties(name: :website_domain_myplet_parameters)

  validates :category, presence: true
  validates :website_domain, presence: true

  def display
    category.display
  end

  def self.params
    [
      :id,
      :_destroy,
      :title,
      :x_coordinate,
      :y_coordinate,
      :border_type,
      :position,
      :notes,
      :singleton,
      :emulate_guest,
      :action,
      category_attributes: [:id],
      website_domain_myplet_parameters_attributes: WebsiteDomainMypletParameter.params,
    ]
  end
  
  def create_for_identity(target_identity, y_coordinate: nil)
    if self.singleton
      new_myplet = nil
    else
      model_attributes = {}
      self.website_domain_myplet_parameters.each do |myplet_param|
        param_value = myplet_param.val
        if Myp.is_probably_i18n(param_value)
          param_value = I18n.t(param_value)
        end
        model_attributes[myplet_param.name] = param_value
      end
      
      new_myplet = self.category.model.create!(model_attributes)
    end
    
    Myplet.create!({
      title: self.title,
      y_coordinate: y_coordinate.nil? ? self.position : y_coordinate,
      x_coordinate: 0,
      category_name: self.category.name,
      category_id: new_myplet.nil? ? nil : new_myplet.id,
      border_type: self.border_type,
      identity: target_identity,
      action: self.action,
    })
  end
  
  def matches?(myplet)
    if myplet.category_name == self.category.name
      true
    else
      false
    end
  end
end
