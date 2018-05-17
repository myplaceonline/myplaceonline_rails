class WalletTransaction < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :transaction_amount, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :transaction_time, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :short_description, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :transaction_identifier, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :exchange_currency, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :exchange_rate, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :fee, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :exchanged_amount, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :wallet_transaction_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  belongs_to :wallet
  
  validates :transaction_amount, presence: true
  
  def display
    Myp.decimal_to_s(value: self.transaction_amount)
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :transaction_amount,
      :transaction_time,
      :short_description,
      :transaction_identifier,
      :exchange_currency,
      :exchange_rate,
      :fee,
      :exchanged_amount,
      :notes,
      contact_attributes: ContactsController.param_names,
      wallet_transaction_files_attributes: FilesController.multi_param_names
    ]
  end

  child_property(name: :contact)
  
  child_files

  def file_folders_parent
    :wallet
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.transaction_time = User.current_user.time_now
    result
  end
  
  after_commit :on_after_change, on: [:create, :update, :destroy]
  
  def on_after_change
    self.wallet.update_balance
  end
end
