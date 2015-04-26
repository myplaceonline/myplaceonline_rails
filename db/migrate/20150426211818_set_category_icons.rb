class SetCategoryIcons < ActiveRecord::Migration
  def change
    set_icon("order", "famfamfam/bricks.png")
    set_icon("joy", "famfamfam/emoticon_smile.png")
    set_icon("meaning", "famfamfam/lightbulb.png")
  end

  def set_icon(name, icon)
    c = Category.where(name: name).first
    c.icon = icon
    c.save!
  end
end
