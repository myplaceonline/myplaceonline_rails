# https://you.23andme.com/tools/data/download/
# Click "Submit Request" at the bottom
class DnaAnalysis < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :import, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  def display
    import.display
  end

  # Effectively required but we don't use `required: true` because this could
  # be a myplet created with no child properties
  child_property(name: :import, destroy_dependent: true)
  
  after_commit :on_after_update, on: [:create, :update]
  
  def on_after_update
    if !self.import.nil?
      self.import.start
    end
  end
  
  def self.evaluate_myplet_homepage_action?
    true
  end
  
  def myplet_homepage_action
    if self.import.nil? || self.import.import_files.count == 0
      :edit
    else
      :show
    end
  end
end
