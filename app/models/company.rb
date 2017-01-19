class Company < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

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
