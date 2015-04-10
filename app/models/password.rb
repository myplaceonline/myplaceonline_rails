require 'kramdown'

class Password < ActiveRecord::Base
  include EncryptedConcern

  belongs_to :identity

  belongs_to :password_encrypted,
      class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :password
  
  has_many :password_secrets, :dependent => :destroy
  accepts_nested_attributes_for :password_secrets, allow_destroy: true, reject_if: :all_blank
  
  validates :name, presence: true
  
  attr_accessor :encrypt
  attr_accessor :is_defunct

  def get_url(prefertls = true)
    result = url
    if !result.to_s.empty?
      if prefertls && result.start_with?("http:")
        result = "https" + result[4..-1]
      end
      
      if (/^[^:]+:.*/ =~ result).nil?
        result = (prefertls ? "https://" : "http://") + result
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
    if !defunct.nil?
      result += " (" + I18n.t("myplaceonline.general.defunct") + ")"
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
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
