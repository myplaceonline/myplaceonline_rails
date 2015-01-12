class Contact < ActiveRecord::Base
  belongs_to :ref, class_name: Identity, :dependent => :destroy
  belongs_to :identity
  accepts_nested_attributes_for :ref, reject_if: :all_blank
  
  validate :custom_validation
  
  has_many :conversations, :dependent => :destroy
  accepts_nested_attributes_for :conversations, allow_destroy: true, reject_if: :all_blank
  
  def custom_validation
    if !contact_identity.nil? && contact_identity.name.blank?
      errors.add(:name, "not specified")
    end
  end

  def name
    contact_identity.name
  end
  
  def birthday
    contact_identity.birthday
  end
  
  def notes
    contact_identity.notes
  end
  
  def contact_identity
    ref
  end

  def as_json(options={})
    super.as_json(options).merge({
      :contact_identity => ref.as_json
    })
  end

  def display
    name
  end
end
