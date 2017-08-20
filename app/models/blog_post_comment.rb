class BlogPostComment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :comment, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :commenter_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :commenter_email, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :commenter_website, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  belongs_to :blog_post
  belongs_to :commenter_identity, class_name: "Identity"
  
  validates :comment, presence: true
  
  validate do
    if self.commenter_name.blank?
      errors.add(:commenter_name, I18n.t("myplaceonline.general.non_blank"))
    end
    if self.commenter_email.blank?
      errors.add(:commenter_email, I18n.t("myplaceonline.general.non_blank"))
    end
  end
  
  def display
    Myp.ellipses_if_needed(self.comment, 32)
  end
  
  def commenter_display
    self.commenter_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :comment,
      :commenter_name,
      :commenter_email,
      :commenter_website,
    ]
  end
end
