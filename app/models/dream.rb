class Dream < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include EncryptedConcern

  validates :dream_time, presence: true
  #validates :dream_name, presence: true
  
  belongs_to :dream_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :dream
  before_validation :dream_finalize
  
  def display
    if dream_name.blank?
      Myp.display_datetime_short(dream_time, User.current_user)
    else
      dream_name + " (" + Myp.display_datetime_short(dream_time, User.current_user) + ")"
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.dream_time = DateTime.now
    result
  end

  def as_json(options={})
    if dream_encrypted?
      options[:except] ||= %w(dream)
    end
    super.as_json(options)
  end

  def self.skip_check_attributes
    ["encrypt"]
  end
end
