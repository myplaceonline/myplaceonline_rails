class IdentityLocation < ActiveRecord::Base
  belongs_to :ref, class: Identity

  belongs_to :location
  accepts_nested_attributes_for :location
  
  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.location = Location.find(attributes['id'])
    end
    super
  end
end
