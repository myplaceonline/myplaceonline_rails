class Company < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :company_identity, type: ApplicationRecord::PROPERTY_TYPE_CHILD, model: Identity },
      { name: :company_interactions, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end
  
  child_property(name: :company_identity, model: Identity, required: true)
  
  child_properties(name: :company_interactions, sort: "company_interaction_date DESC")

  validate :custom_validation

  def custom_validation
    if !company_identity.nil? && company_identity.name.blank? && company_identity.last_name.blank? && company_identity.nickname.blank?
      errors.add(:name, "not specified")
    end
  end
  
  def display
    company_identity.display
  end

  def self.param_names(include_website: true, recurse: true)
    [
      :id,
      :_destroy,
      company_identity_attributes: Identity.param_names(include_website: include_website, recurse: recurse, include_company: false),
      company_interactions_attributes: CompanyInteraction.params,
    ]
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    if !company_identity.nil?
      put_files_in_folder(company_identity.identity_pictures, [I18n.t("myplaceonline.category.companies"), display])
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.company_identity = Myp.new_model(Identity)
    result.company_identity.identity_type = Identity::IDENTITY_TYPE_COMPANY
    result
  end

  def as_json(options={})
    super.as_json(options).merge({
      :company_identity => company_identity.as_json
    })
  end
  
  def self.search_filters
    { identity_type: 1 }
  end
end
