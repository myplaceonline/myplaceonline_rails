class SetCalculationFormsExperimental < ActiveRecord::Migration
  def change
    c = Category.where(name: "calculation_forms").first
    c.experimental = true
    c.save!

    c = Category.where(name: "calculations").first
    c.experimental = true
    c.save!
  end
end
