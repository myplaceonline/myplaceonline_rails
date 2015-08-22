class Company < MyplaceonlineActiveRecord
  include AllowExistingConcern

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
end
