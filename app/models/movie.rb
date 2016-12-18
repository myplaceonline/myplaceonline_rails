class Movie < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern

  validates :name, presence: true
  attr_accessor :is_watched
  boolean_time_transfer :is_watched, :watched
  
  belongs_to :recommender, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :recommender, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :recommender, Contact

  belongs_to :lent_to, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :lent_to, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :lent_to, Contact
  
  belongs_to :borrowed_from, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :borrowed_from, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :borrowed_from, Contact

  def display
    name
  end
end
