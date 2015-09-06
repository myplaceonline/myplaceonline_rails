# x_coordinate:integer y_coordinate:integer title:string category_name:string category_id:integer border_type:integer collapsed:boolean
class Myplet < MyplaceonlineIdentityRecord
  def display
    nil
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
      owner: identity
    }))

    x = MyplaceonlineSearch.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.myplaceonline_search",
      y_coordinate: 1,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 1,
      owner: identity
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
      owner: identity
    }))

    x = MyplaceonlineDueDisplay.new
    x.save!
    result.push(Myplet.new({
      title: "myplaceonline.myplets.titles.myplaceonline_due_display",
      y_coordinate: 3,
      x_coordinate: 0,
      category_name: x.class.name.underscore.pluralize,
      category_id: x.id,
      border_type: 1,
      owner: identity
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
      owner: identity
    }))
    
    result.each do |myplet|
      myplet.save!
    end
    
    result
  end
end
