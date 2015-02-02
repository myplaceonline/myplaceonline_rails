class Company < ActiveRecord::Base
  belongs_to :identity

  validates :name, presence: true
  
  def display
    name
  end

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if attributes['id'].present?
      self.location = Location.find(attributes['id'])
    end
    super
  end
  
  validates_each :location do |record, attr, value|
    Myp.authorize_value(record, attr, value)
  end

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json
    })
  end
end
