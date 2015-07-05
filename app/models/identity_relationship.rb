class IdentityRelationship < ActiveRecord::Base
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
    ["myplaceonline.relationships.friend", 15]
  ]

  belongs_to :owner, class: Identity
  belongs_to :ref, class: Identity
  
  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def contact_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.contact = Contact.find(attributes['id'])
    end
    super
  end
  
  def relationship_name
    if relationship_type.nil?
      nil
    else
      Myp.get_select_name(relationship_type, IdentityRelationship::RELATIONSHIPS)
    end
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
