class Apartment < ActiveRecord::Base
  belongs_to :location
  belongs_to :identity
  validates_presence_of :location
  accepts_nested_attributes_for :location
  
  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json
    })
  end
end
