class PasswordSecret < ActiveRecord::Base
  belongs_to :password
  belongs_to :encrypted_answer, class_name: EncryptedValue, dependent: :destroy
end
