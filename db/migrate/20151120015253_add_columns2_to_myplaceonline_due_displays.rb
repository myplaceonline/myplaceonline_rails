class AddColumns2ToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :dentist_visit_threshold, :integer
    add_column :myplaceonline_due_displays, :doctor_visit_threshold, :integer
    add_column :myplaceonline_due_displays, :status_threshold, :integer
    add_column :myplaceonline_due_displays, :trash_pickup_threshold, :integer
    add_column :myplaceonline_due_displays, :periodic_payment_before_threshold, :integer
    add_column :myplaceonline_due_displays, :periodic_payment_after_threshold, :integer
  end
end
