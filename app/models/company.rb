class Company < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :company_identity, model: Identity)
  
#   validate :custom_validation
# 
#   def custom_validation
#     if !company_identity.nil? && company_identity.name.blank? && company_identity.last_name.blank? && company_identity.nickname.blank?
#       errors.add(:name, "not specified")
#     end
#   end
  
  validates :name, presence: true
  
  def display
    name
  end

  child_property(name: :location)

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json
    })
  end
end
