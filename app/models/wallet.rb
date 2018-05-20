class Wallet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :wallet_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :balance, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :currency_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :wallet_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :wallet_transactions, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  CURRENCY_US_DOLLARS = 0
  CURRENCY_EUROS = 1
  CURRENCY_POUNDS = 2
  CURRENCY_YEN = 3
  CURRENCY_CANADIAN_DOLLARS = 4
  CURRENCY_RENMINBI = 5
  CURRENCY_FRANCS = 6
  CURRENCY_BITCOIN = 7
  CURRENCY_ETHEREUM = 8
  CURRENCY_BITCOIN_CASH = 9

  CURRENCY_TYPES = [
    ["myplaceonline.wallets.currency_types.us_dollars", CURRENCY_US_DOLLARS],
    ["myplaceonline.wallets.currency_types.euros", CURRENCY_EUROS],
    ["myplaceonline.wallets.currency_types.pounds", CURRENCY_POUNDS],
    ["myplaceonline.wallets.currency_types.yen", CURRENCY_YEN],
    ["myplaceonline.wallets.currency_types.canadian_dollars", CURRENCY_CANADIAN_DOLLARS],
    ["myplaceonline.wallets.currency_types.renminbi", CURRENCY_RENMINBI],
    ["myplaceonline.wallets.currency_types.francs", CURRENCY_FRANCS],
    ["myplaceonline.wallets.currency_types.bitcoin", CURRENCY_BITCOIN],
    ["myplaceonline.wallets.currency_types.ethereum", CURRENCY_ETHEREUM],
    ["myplaceonline.wallets.currency_types.bitcoin_cash", CURRENCY_BITCOIN_CASH],
  ]

  validates :wallet_name, presence: true
  validates :balance, presence: true
  
  def display
    wallet_name
  end

  child_files

  child_property(name: :password)
  
  child_properties(name: :wallet_transactions, sort: "created_at DESC")

  def self.build(params = nil)
    result = self.dobuild(params)
    result.balance = 0
    result
  end
  
  def update_balance
    total = 0
    self.wallet_transactions.each do |wt|
      total = total + wt.transaction_amount
    end
    self.balance = total
    self.save!
  end
  
  def estimate_balance_in_primary_currency
    c = self.currency_type
    if c.nil?
      c = CURRENCY_US_DOLLARS
    end
    case c
    when CURRENCY_US_DOLLARS
      self.balance
    else
      Myp.warn("Currency estimation unavailable for #{self.id}")
      raise "Currency estimation unavailable for #{Myp.get_select_name(c, CURRENCY_TYPES)}"
    end
  end
end
