require 'kramdown'

class Password < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include EncryptedConcern
  include ModelHelpersConcern
  
  def self.properties
    [
      { name: :name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :user, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :email, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :url, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :account_number, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :encrypt, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :password_secrets, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  belongs_to :password_encrypted, class_name: "EncryptedValue", dependent: :destroy, :autosave => true
  belongs_to_encrypted :password
  before_validation :password_finalize
  before_validation :set_encrypt_for_secrets
  
  child_properties(name: :password_secrets)
  
  validates :name, presence: true
  
  def set_encrypt_for_secrets
    password_secrets.each do |secret|
      secret.encrypt = encrypt
    end
  end

  def get_url(prefertls = true)
    result = url
    if !result.to_s.empty?
      if prefertls && result.start_with?("http:")
        #result = "https" + result[4..-1]
      end
      
      if (/^[^:]+:.*/ =~ result).nil?
        #result = (prefertls ? "https://" : "http://") + result
      end
    end
    result
  end
  
  def display
    result = name
    if !user.blank?
      if name != user
        result += " (" + user + ")"
      end
    elsif !email.blank?
      if name != email
        result += " (" + email + ")"
      end
    end
    if !archived.nil?
      result += " (" + I18n.t("myplaceonline.general.archived") + ")"
    end
    result
  end
  
  def as_json(options={})
    if password_encrypted?
      options[:except] ||= "password"
    end
    super.as_json(options).merge({
      :password_secrets => password_secrets.to_a.map{|x| x.as_json}
    })
  end

  def self.skip_check_attributes
    ["encrypt"]
  end
end
