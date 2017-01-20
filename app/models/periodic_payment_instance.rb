class PeriodicPaymentInstance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :periodic_payment
  
  validates :payment_date, presence: true
  
  def display
    Myp.appendstrwrap(periodic_payment.display, Myp.display_datetime_short(self.payment_date, User.current_user))
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :payment_date,
      :amount,
      :notes,
      periodic_payment_instance_files_attributes: FilesController.multi_param_names
    ]
  end

  child_files

  def file_folders_parent
    :periodic_payment
  end
end
