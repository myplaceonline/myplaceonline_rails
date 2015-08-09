class Company < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity

  validates :name, presence: true
  
  def display
    name
  end

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json
    })
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
