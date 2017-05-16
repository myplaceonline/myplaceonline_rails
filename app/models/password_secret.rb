class PasswordSecret < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include EncryptedConcern

  def self.properties
    [
      { name: :question, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :answer, type: ApplicationRecord::PROPERTY_TYPE_STRING },
    ]
  end

  belongs_to :password
  
  belongs_to :answer_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :answer
  before_validation :answer_finalize

  def as_json(options={})
    if answer_encrypted?
      options[:except] ||= "answer"
    end
    super.as_json(options)
  end
  
  def final_search_result
    password
  end
end
