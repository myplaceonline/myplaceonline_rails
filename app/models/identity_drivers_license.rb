class IdentityDriversLicense < ActiveRecord::Base
  belongs_to :ref, class: Identity
  belongs_to :identity
  
  validates :identifier, presence: true

  belongs_to :identity_file, :dependent => :destroy
  accepts_nested_attributes_for :identity_file, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save
  
  def display
    identifier
  end

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
