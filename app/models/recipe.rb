class Recipe < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  # https://en.wikipedia.org/wiki/List_of_cooking_techniques
  RECIPE_TYPE_PAN_FRY = 0
  RECIPE_TYPE_BAKE = 1
  RECIPE_TYPE_BBQ = 2
  RECIPE_TYPE_BOIL = 3
  RECIPE_TYPE_GRILL = 4
  RECIPE_TYPE_SOUSVIDE = 5
  RECIPE_TYPE_MICROWAVE = 6
  RECIPE_TYPE_PRESSURE = 7
  RECIPE_TYPE_SLOW_COOKER = 8
  RECIPE_TYPE_SMOKE = 9
  RECIPE_TYPE_STEAM = 10

  RECIPE_TYPES = [
    ["myplaceonline.recipes.recipe_types.pan_fry", RECIPE_TYPE_PAN_FRY],
    ["myplaceonline.recipes.recipe_types.bake", RECIPE_TYPE_BAKE],
    ["myplaceonline.recipes.recipe_types.bbq", RECIPE_TYPE_BBQ],
    ["myplaceonline.recipes.recipe_types.boil", RECIPE_TYPE_BOIL],
    ["myplaceonline.recipes.recipe_types.grill", RECIPE_TYPE_GRILL],
    ["myplaceonline.recipes.recipe_types.sousvide", RECIPE_TYPE_SOUSVIDE],
    ["myplaceonline.recipes.recipe_types.microwave", RECIPE_TYPE_MICROWAVE],
    ["myplaceonline.recipes.recipe_types.pressure", RECIPE_TYPE_PRESSURE],
    ["myplaceonline.recipes.recipe_types.slow_cooker", RECIPE_TYPE_SLOW_COOKER],
    ["myplaceonline.recipes.recipe_types.smoke", RECIPE_TYPE_SMOKE],
    ["myplaceonline.recipes.recipe_types.steam", RECIPE_TYPE_STEAM],
  ]

  validates :name, presence: true
  
  def display
    Myp.appendstrwrap(name, Myp.get_select_name(self.recipe_type, RECIPE_TYPES))
  end

  child_pictures
end
