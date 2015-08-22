class IdentityEmail < MyplaceonlineActiveRecord
  belongs_to :identity, class_name: Identity
end
