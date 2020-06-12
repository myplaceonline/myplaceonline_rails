class AddCategoryWirelessNetworks < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "wireless_networks", link: "wireless_networks", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/wi_fi.png", additional_filtertext: "wifi")
  end
end
