class Receipt < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :receipt_name, presence: true
  validates :receipt_time, presence: true
  
  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(receipt_files, [I18n.t("myplaceonline.category.receipts"), display])
  end

  child_properties(name: :receipt_files, sort: "position ASC, updated_at ASC")

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
