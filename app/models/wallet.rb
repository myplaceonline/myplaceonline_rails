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
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.balance = 0
    result
  end
end
