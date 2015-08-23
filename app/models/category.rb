class Category < MyplaceonlineModelBase
  belongs_to :parent, class_name: Category
  has_many :category_points_amounts
  
  def human_title
    Category.human_title(name)
  end
  
  def filtertext
    Category.filtertext(name, additional_filtertext)
  end
  
  def self.human_title(name)
    I18n.t("myplaceonline.category." + name.downcase)
  end
  
  def self.filtertext(name, additional_filtertext)
    result = self.human_title(name)
    if !additional_filtertext.nil?
      result += " " + additional_filtertext
    end
    result
  end
end
