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
      category_attributes: [:id],
      website_domain_myplet_parameters_attributes: WebsiteDomainMypletParameter.params,
    ]
  end
end
