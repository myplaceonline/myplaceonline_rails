class PaypalWebProfile < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern
  
  belongs_to :website_domain
end
