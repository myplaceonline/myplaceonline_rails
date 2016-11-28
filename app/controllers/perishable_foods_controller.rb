class PerishableFoodsController < MyplaceonlineController
  def search_index_name
    Food.table_name
  end

  def search_parent_category
    category_name.singularize
  end
  
  def consume_one
    set_obj
    if @obj.quantity.nil? || @obj.quantity <= 1
      consume_all
    else
      @obj.update_column(:quantity, @obj.quantity - 1)
      redirect_to(
        obj_path,
        :flash => {:notice => I18n.t("myplaceonline.perishable_foods.one_consumed", name: @obj.display) }
      )
    end
  end

  def consume_all
    set_obj
    # Do a full save with callbacks so that any reminders are deleted
    @obj.quantity = 0
    @obj.save!
    archive(notice: I18n.t("myplaceonline.perishable_foods.all_consumed", name: @obj.display))
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.perishable_foods.consume_one"),
        link: perishable_food_consume_one_path(@obj),
        icon: "tag"
      },
      {
        title: I18n.t("myplaceonline.perishable_foods.consume_all"),
        link: perishable_food_consume_all_path(@obj),
        icon: "check"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["perishable_foods.updated_at DESC"]
    end

    def obj_params
      params.require(:perishable_food).permit(
        :purchased,
        :expires,
        :storage_location,
        :notes,
        :quantity,
        food_attributes: Food.params
      )
    end

    def sorts
      ["foods.food_name ASC"]
    end
    
    def all_joins
      "INNER JOIN foods ON foods.id = perishable_foods.food_id"
    end

    def all_includes
      :food
    end
end
