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

  validates :invoice_description, presence: true
  validates :invoice_time, presence: true
  validates :invoice_amount, presence: true
  validates :invoice_status, presence: true
  
  def display
    Myp.appendstrwrap(self.invoice_description, Myp.number_to_currency(invoice_amount))
  end

  def read_only?
    result = true
    
    result
  end
end
