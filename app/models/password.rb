require 'kramdown'

class Password < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include EncryptedConcern
  include ModelHelpersConcern
  
  belongs_to :password_encrypted, class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :password
  before_validation :password_finalize
  before_validation :set_encrypt_for_secrets
  
  has_many :password_secrets, :dependent => :destroy
  accepts_nested_attributes_for :password_secrets, allow_destroy: true, reject_if: :all_blank
  
  validates :name, presence: true
  
  attr_accessor :is_archived
  boolean_time_transfer :is_archived, :archived
  
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
      result += " (" + user + ")"
    elsif !email.blank?
      result += " (" + email + ")"
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
end
