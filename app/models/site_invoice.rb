class SiteInvoice < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :invoice_description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :invoice_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :invoice_amount, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :invoice_status, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :model_class, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :model_id, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  INVOICE_STATUS_PENDING = 0
  INVOICE_STATUS_PAID = 1

  INVOICE_STATUSES = [
    ["myplaceonline.site_invoices.invoice_statuses.pending", INVOICE_STATUS_PENDING],
    ["myplaceonline.site_invoices.invoice_statuses.paid", INVOICE_STATUS_PAID],
  ]
  
  PAYMENT_TYPE_PAYPAL = 0

  validates :invoice_description, presence: true
  validates :invoice_time, presence: true
  validates :invoice_amount, presence: true
  validates :invoice_status, presence: true
  
  def display
    Myp.appendstrwrap(self.invoice_description, Myp.number_to_currency(invoice_amount))
  end

  def read_only?(action: nil)
    case action
    when :pay, :paypal_complete, :pay_other
      result = false
    else
      result = true
    end
    result
  end
  
  def allow_admin?
    true
  end

  def next_charge
    result = self.invoice_amount
    if self.total_paid.nil?
      if !self.first_charge.nil?
        result = self.first_charge
      end
    else
      result = result - self.total_paid
    end
    result
  end
  
  def remaining
    result = self.invoice_amount
    if !self.total_paid.nil?
      result = result - self.total_paid
    end
    result
  end
  
  def paid?
    self.remaining == 0
  end
  
  def find_model_class
    Object.const_get(self.model_class)
  end
  
  def find_model_object
    if !self.model_id.nil?
      find_model_class.find(self.model_id.to_i)
    else
      nil
    end
  end
end
