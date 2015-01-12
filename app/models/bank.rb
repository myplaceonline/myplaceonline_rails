class Bank < ActiveRecord::Base
  belongs_to :identity

  belongs_to :location
  validates_presence_of :location
  accepts_nested_attributes_for :location
  
  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if attributes['id'].present?
      self.location = Location.find(attributes['id'])
    end
    super
  end

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def password_attributes=(attributes)
    if attributes['id'].present?
      self.password = Password.find(attributes['id'])
    end
    super
  end
  
  validates_each :location, :password do |record, attr, value|
    Myp.authorize_value(record, attr, value)
  end

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :password => password.as_json
    })
  end
end
