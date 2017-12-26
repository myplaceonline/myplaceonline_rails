# http://dbpedia.org/ontology/Agent
class Agent < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
    ]
  end
  
  child_property(name: :agent_identity, model: Identity, required: true)
  
  def custom_validation
    if !agent_identity.nil? && agent_identity.name.blank? && agent_identity.last_name.blank? && agent_identity.nickname.blank?
      errors.add(:name, "not specified")
    end
  end
  
  def display
    agent_identity.display
  end

  def self.param_names(include_website: true, recurse: true)
    [
      :id,
      :_destroy,
      agent_identity_attributes: Identity.param_names(include_website: include_website, recurse: recurse, include_company: true),
    ]
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    if !agent_identity.nil?
      put_files_in_folder(agent_identity.identity_pictures, [I18n.t("myplaceonline.category.agents"), display])
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.agent_identity = Myp.new_model(Identity)
    result.agent_identity.identity_type = Identity::IDENTITY_TYPE_AGENT
    result
  end

  def as_json(options={})
    super.as_json(options).merge({
      :agent_identity => agent_identity.as_json
    })
  end
  
  def self.search_filters
    { identity_type: Identity::IDENTITY_TYPE_AGENT }
  end
  
  def self.search_id_column
    :agent_identity_id
  end

  def read_only?(action: nil)
    result = false
    
    reputation_report = ReputationReport.where(agent_id: self.id).take
    if !reputation_report.nil?
      result = reputation_report.read_only?(action: action)
    end
    
    result
  end

  def allow_admin?
    if !ReputationReport.where(agent_id: self.id).take.nil?
      true
    else
      false
    end
  end
end
