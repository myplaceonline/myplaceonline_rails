class Book < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern
  
  validates :book_name, presence: true
  
  boolean_time_transfer :is_read, :when_read
  
  belongs_to :recommender, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :recommender, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :recommender, Contact
  
  belongs_to :lent_to, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :lent_to, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :lent_to, Contact
  
  belongs_to :borrowed_from, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :borrowed_from, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :borrowed_from, Contact
  
  has_many :book_quotes, -> { order("pages ASC, updated_at DESC") }, :dependent => :destroy
  accepts_nested_attributes_for :book_quotes, allow_destroy: true, reject_if: :all_blank
  
  has_many :book_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :book_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :book_files, [{:name => :identity_file}]

  before_validation :update_file_folders

  def update_file_folders
    put_files_in_folder(book_files, [I18n.t("myplaceonline.category.books"), display])
  end

  def display
    Myp.appendstrwrap(book_name, author)
  end
end
