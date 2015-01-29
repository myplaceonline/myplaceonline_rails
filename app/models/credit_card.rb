class CreditCard < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  validates :number, presence: true
  validates :expires, presence: true
  validates :security_code, presence: true
  
  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def password_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.password = Password.find(attributes['id'])
    end
    super
  end
end
