class PerishableFoodsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:update_blank_location]

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
        :flash => {:notice => I18n.t("myplaceonline.perishable_foods.one_consumed", name: @obj.display(show_quantity: false)) }
      )
    end
  end

  def regurgitate_one
    set_obj
    if @obj.archived?
      @obj.update_column(:archived, nil)
      @obj.update_column(:quantity, 1)
    elsif @obj.quantity.nil? || @obj.quantity <= 1
      @obj.update_column(:quantity, 2)
    else
      @obj.update_column(:quantity, @obj.quantity + 1)
    end
    redirect_to(
      obj_path,
      :flash => {:notice => I18n.t("myplaceonline.perishable_foods.one_regurgitated", name: @obj.display(show_quantity: false)) }
    )
  end

  def consume_all
    set_obj
    # Do a full save with callbacks so that any reminders are deleted
    @obj.quantity = 0
    @obj.save!
    archive(notice: I18n.t("myplaceonline.perishable_foods.all_consumed", name: @obj.display(show_quantity: false)))
  end
  
  def move
    set_obj
    
    previous_quantity = @obj.quantity
    previous_storage_location = @obj.storage_location
    
    if @obj.quantity.nil?
      @obj.quantity = 1
    end
    
    if request.patch?
      new_quantity = params[:perishable_food][:quantity].to_i
      new_storage_location = params[:perishable_food][:storage_location]
      
      if previous_storage_location != new_storage_location || previous_quantity != new_quantity
        if previous_quantity.nil? || previous_quantity <= 1 || new_quantity == previous_quantity

          # Moving all items is effectively just updating the storage location, so there's no need to update reminders.
          @obj.update_column(:storage_location, new_storage_location)
          
          redirect_to(
            obj_path,
            :flash => {:notice => I18n.t("myplaceonline.perishable_foods.moved_all", name: @obj.display) }
          )
        else
          remaining_quantity = previous_quantity - new_quantity
          
          # No need for the callbacks since the reminder will be the same
          @obj.update_column(:storage_location, new_storage_location)
          @obj.update_column(:quantity, new_quantity)
          
          remaining_obj = @obj.dup
          remaining_obj.quantity = remaining_quantity
          remaining_obj.storage_location = previous_storage_location
          remaining_obj.save!

          redirect_to(
            obj_path,
            :flash => {:notice => I18n.t(
                                         "myplaceonline.perishable_foods.moved_some",
                                         name: @obj.display,
                                         quantity: new_quantity
                                        ) }
          )
        end
      else
        flash[:error] = t("myplaceonline.perishable_foods.nothing_updated")
        render :move
      end
    else
      render :move
    end
  end

  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.perishable_foods.consume_one"),
        link: perishable_food_consume_one_path(@obj),
        icon: "check"
      }
      
      result << {
        title: I18n.t("myplaceonline.perishable_foods.regurgitate_one"),
        link: perishable_food_regurgitate_one_path(@obj),
        icon: "check"
      }
      
      result << {
        title: I18n.t("myplaceonline.perishable_foods.consume_all"),
        link: perishable_food_consume_all_path(@obj),
        icon: "bullets"
      }
    end
    
    result = result + super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.perishable_foods.move"),
        link: perishable_food_move_path(@obj),
        icon: "navigation"
      }
    end
    
    return result
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.expires, User.current_user)
  end
    
  def data_split_icon
    "check"
  end
  
  def split_link(obj)
    if !MyplaceonlineExecutionContext.offline?
      ActionController::Base.helpers.link_to(
        I18n.t("myplaceonline.perishable_foods.consume_one"),
        perishable_food_consume_one_path(obj)
      )
    else
      nil
    end
  end
  
  def index_sorts
    [
      [I18n.t("myplaceonline.perishable_foods.expires"), "perishable_foods.expires"],
    ] + super
  end
  
  def footer_items_index
    result = super
    
    if params[:without_location].blank?
      result << {
        title: I18n.t("myplaceonline.perishable_foods.without_location"),
        link: perishable_foods_path(without_location: true),
        icon: "alert"
      }
    else
      result << {
        title: I18n.t("myplaceonline.general.all"),
        link: perishable_foods_path,
        icon: "bullets"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.perishable_foods.update_blank_location"),
      link: perishable_foods_update_blank_location_path,
      icon: "location"
    }

    result
  end
  
  def update_blank_location
    if request.post? && !params[:new_location].blank?
      updated_count = 0
      ActiveRecord::Base.transaction do
        all.each do |item|
          if item.storage_location.blank?
            item.storage_location = params[:new_location]
            item.save!
            updated_count = updated_count + 1
          end
        end
      end
      redirect_to(
        index_path,
        :flash => {:notice => I18n.t("myplaceonline.perishable_foods.blank_location_updated", count: updated_count, location: params[:new_location]) }
      )
    end
  end
  
  protected
    def insecure
      true
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

    def additional_sorts
      [
        [I18n.t("myplaceonline.foods.food_name"), "lower(foods.food_name)"],
        [I18n.t("myplaceonline.perishable_foods.storage_location"), "lower(perishable_foods.storage_location)"],
      ]
    end

    def default_sort_columns
      ["perishable_foods.expires"]
    end
    
    def all_joins
      "INNER JOIN foods ON foods.id = perishable_foods.food_id"
    end

    def all_includes
      :food
    end
    
    def all_additional_sql(strict)
      result = super(strict)
      if result.nil?
        result = ""
      end
      if params[:without_location] == "true"
        result << " AND (perishable_foods.storage_location IS NULL OR perishable_foods.storage_location = '')"
      end
      return result
    end
end
