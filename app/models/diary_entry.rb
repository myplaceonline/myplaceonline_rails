class DiaryEntry < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include EncryptedConcern

  validates :diary_time, presence: true
  validates :diary_title, presence: true
  
  belongs_to :entry_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :entry
  before_validation :entry_finalize
  
  def display
    if diary_title.blank?
      Myp.display_datetime_short(diary_time, User.current_user)
    else
      diary_title + " (" + Myp.display_datetime_short(diary_time, User.current_user) + ")"
    end
  end
  
  validate do
    if entry.blank? && entry_encrypted.nil?
      errors.add(:entry, I18n.t("myplaceonline.general.non_blank"))
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.diary_time = DateTime.now
    result
  end

  def as_json(options={})
    if entry_encrypted?
      options[:except] ||= %w(entry)
    end
    super.as_json(options)
  end
end
