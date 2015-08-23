class IdentityPhone < MyplaceonlineIdentityRecord
  PHONE_TYPES = [
    ["myplaceonline.identity_phones.cell", 0],
    ["myplaceonline.identity_phones.home", 1],
    ["myplaceonline.identity_phones.temporary", 2]
  ]
  
  belongs_to :identity, class_name: Identity
end
