class PasswordSecret < ActiveRecord::Base
  include EncryptedConcern
  belongs_to :password
  belongs_to :answer_encrypted,
      class_name: EncryptedValue, dependent: :destroy, :autosave => true
  belongs_to_encrypted :answer
end
