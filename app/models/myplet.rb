# x_coordinate:integer y_coordinate:integer title:string category_name:string category_id:integer border_type:integer collapsed:boolean
class Myplet < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  BORDER_TYPES = [
    ["myplaceonline.border_types.none", 0],
    ["myplaceonline.border_types.title", 1]
  ]

  def display
    Myp.evaluate_if_probably_i18n(title)
  end
  
  validate do
    # Make sure the user has access to this object
    if !category_name.blank? && !category_id.nil?
      cls = Object.const_get(category_name.camelize.singularize)
      if cls.where(id: category_id, identity: User.current_user.primary_identity).count == 0
        errors.add(:category_id, I18n.t("myplaceonline.general.not_auhorized"))
      end
    end
  end

  def self.default_myplets(identity)
    result = Array.new

    x = PointDisplay.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.point_display",
      y_coordinate: 0,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 0,
      identity: identity
    }))

    x = MyplaceonlineSearch.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.myplaceonline_search",
      y_coordinate: 1,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 0,
      identity: identity
    }))

    x = MyplaceonlineQuickCategoryDisplay.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.myplaceonline_quick_category_display",
      y_coordinate: 2,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 1,
      identity: identity
    }))

    x = Calendar.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.calendar",
      y_coordinate: 3,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 1,
      identity: identity
    }))

    x = Notepad.new({
      title: I18n.t("myplaceonline.myplets.titles.notepad")
    })
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.notepad",
      y_coordinate: 4,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 1,
      identity: identity
    }))
    
    result.each do |myplet|
      myplet.save!
    end
    
    result
  end
  
  def show_highly_visited?
    false
  end
end
