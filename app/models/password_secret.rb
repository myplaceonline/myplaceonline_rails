class PasswordSecret < ActiveRecord::Base
  include EncryptedConcern
  belongs_to :owner, class: Identity
  belongs_to :password
  belongs_to :answer_encrypted,
      class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :answer

  def as_json(options={})
    if answer_encrypted?
      options[:except] ||= "answer"
    end
    super.as_json(options)
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
