class AddIcons < ActiveRecord::Migration
  def change
    set_icon("accomplishments", "famfamfam/award_star_gold_1.png")
    set_icon("companies", "famfamfam/building.png")
    set_icon("calculation_forms", "famfamfam/calculator.png")
    set_icon("calculations", "famfamfam/calculator_add.png")
    set_icon("credit_cards", "famfamfam/creditcards.png")
    set_icon("jokes", "famfamfam/emoticon_tongue.png")
    set_icon("feeds", "famfamfam/feed.png")
    set_icon("contacts", "famfamfam/group.png")
    set_icon("questions", "famfamfam/help.png")
    set_icon("locations", "famfamfam/map.png")
    set_icon("ideas", "famfamfam/lightning.png")
    set_icon("recreational_vehicles", "famfamfam/lorry.png")
    set_icon("lists", "famfamfam/note.png")
    set_icon("sleep_measurements", "famfamfam/status_away.png")
    set_icon("subscriptions", "famfamfam/transmit.png")
    set_icon("movies", "famfamfam/film.png")
    set_icon("apartments", "famfamfam/house.png")
    set_icon("files", "famfamfam/attach.png")
    set_icon("promises", "famfamfam/asterisk_orange.png")
    set_icon("to_dos", "famfamfam/calendar.png")
  end

  def set_icon(name, icon)
    c = Category.where(name: name).first
    if !c.nil?
      c.icon = icon
      c.save!
    end
  end
end
