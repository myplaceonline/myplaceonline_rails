class Bank < ActiveRecord::Base
  belongs_to :identity

  belongs_to :location
  validates_presence_of :location
  accepts_nested_attributes_for :location

  belongs_to :password
  validates_presence_of :password
  accepts_nested_attributes_for :password
  
  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :password => password.as_json
    })
  end
end
