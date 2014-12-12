class PasswordSecret < ActiveRecord::Base
  belongs_to :password
  belongs_to :encrypted_answer, class_name: EncryptedValue, dependent: :destroy
  
  def getAnswer(session)
    if !is_encrypted_answer
      answer
    else
      Myp.decrypt_from_session(session, encrypted_answer)
    end
  end
end
