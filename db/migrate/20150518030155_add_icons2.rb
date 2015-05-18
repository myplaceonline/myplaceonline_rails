class AddIcons2 < ActiveRecord::Migration
  def change
    set_icon("acne_measurements", "FatCow_Icons16x16/bubblechart_red.png")
    set_icon("activities", "FatCow_Icons16x16/direction.png")
    set_icon("bank_accounts", "FatCow_Icons16x16/bank.png")
    set_icon("blood_pressures", "FatCow_Icons16x16/celsius.png")
    set_icon("health", "FatCow_Icons16x16/health.png")
    set_icon("heart_rates", "FatCow_Icons16x16/heart.png")
    set_icon("medicine_usages", "FatCow_Icons16x16/injection.png")
    set_icon("credit_reports", "FatCow_Icons16x16/legend.png")
    set_icon("meals", "FatCow_Icons16x16/omelet.png")
    set_icon("websites", "FatCow_Icons16x16/page_world.png")
    set_icon("heights", "FatCow_Icons16x16/ruler.png")
    set_icon("exercises", "FatCow_Icons16x16/shoe.png")
    set_icon("credit_scores", "FatCow_Icons16x16/table_money.png")
    set_icon("sun_exposures", "FatCow_Icons16x16/weather_sun.png")
    set_icon("weights", "FatCow_Icons16x16/weighing_mashine.png")
    set_icon("wisdoms", "FatCow_Icons16x16/brain.png")
    set_icon("recipes", "FatCow_Icons16x16/chefs_hat.png")
  end

  def set_icon(name, icon)
    c = Category.where(name: name).first
    if !c.nil?
      c.icon = icon
      c.save!
    end
  end
end
