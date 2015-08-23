class IdentityEmail < MyplaceonlineIdentityRecord
  belongs_to :identity, class_name: Identity
end
