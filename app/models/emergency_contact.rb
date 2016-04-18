class EmergencyContact < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :email, presence: true

  belongs_to :email, :dependent => :destroy
  accepts_nested_attributes_for :email, reject_if: :all_blank

  def display
    email.all_targets.values.to_a.map{|x| x.display }.join(", ")
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.email = Email.new
    result.email.set_subject("N/A")
    result.email.set_body_if_blank("N/A")
    result.email.draft = true
    result.email.email_category = I18n.t("myplaceonline.emails.category_emergency")
    result
  end
end
