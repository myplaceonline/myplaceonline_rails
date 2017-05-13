class IdentityRelationship < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :relationship_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end
  
  RELATIONSHIPS = [
    ["myplaceonline.relationships.sister", 0],
    ["myplaceonline.relationships.brother", 1],
    ["myplaceonline.relationships.son", 2],
    ["myplaceonline.relationships.daughter", 3],
    ["myplaceonline.relationships.wife", 4],
    ["myplaceonline.relationships.husband", 5],
    ["myplaceonline.relationships.partner", 6],
    ["myplaceonline.relationships.girlfriend", 7],
    ["myplaceonline.relationships.boyfriend", 8],
    ["myplaceonline.relationships.father", 9],
    ["myplaceonline.relationships.mother", 10],
    ["myplaceonline.relationships.aunt", 11],
    ["myplaceonline.relationships.uncle", 12],
    ["myplaceonline.relationships.grandmother", 13],
    ["myplaceonline.relationships.grandfather", 14],
    ["myplaceonline.relationships.friend", 15],
    ["myplaceonline.relationships.dog", 16],
    ["myplaceonline.relationships.cat", 17],
    ["myplaceonline.relationships.coworker", 18],
  ]

  belongs_to :parent_identity, class_name: Identity
  
  child_property(name: :contact)
  
  def relationship_name
    if relationship_type.nil?
      nil
    else
      Myp.get_select_name(relationship_type, IdentityRelationship::RELATIONSHIPS)
    end
  end
end
