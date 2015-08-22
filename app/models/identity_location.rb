class IdentityLocation < MyplaceonlineActiveRecord
  include AllowExistingConcern

  belongs_to :identity, class_name: Identity

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: :all_blank
  allow_existing :location
end
