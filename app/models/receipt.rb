class Receipt < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :receipt_name, presence: true
  validates :receipt_time, presence: true
  
  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(receipt_files, [I18n.t("myplaceonline.category.receipts"), display])
  end

  has_many :receipt_files, :dependent => :destroy
  accepts_nested_attributes_for :receipt_files, allow_destroy: true, reject_if: :all_blank

  def display
    Myp.appendstrwrap(receipt_name, Myp.display_datetime_short(receipt_time, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.receipt_time = Time.now
    result
  end
end
