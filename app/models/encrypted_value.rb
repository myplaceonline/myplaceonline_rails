require "base64"

class EncryptedValue < ActiveRecord::Base
  include MyplaceonlineActiveRecordBaseConcern

  belongs_to :user
  
  def as_json(options={})
    {
      :id => id,
      :val => ::Base64.strict_encode64(val),
      :salt => ::Base64.strict_encode64(salt),
      :user_id => user_id,
      :created_at => created_at,
      :updated_at => updated_at,
      :encryption_type => encryption_type
    }
  end
end
