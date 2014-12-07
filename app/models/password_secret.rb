class PasswordSecret < ActiveRecord::Base
  belongs_to :password
  belongs_to :encrypted_answer, class_name: EncryptedValue, dependent: :destroy
  
  def getAnswer(session)
    Myp.decryptFromSession(session, encrypted_answer)
  end
end
