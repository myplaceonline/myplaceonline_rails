class AddColumns10ToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :website_domain_registration_threshold, :integer
  end
end
