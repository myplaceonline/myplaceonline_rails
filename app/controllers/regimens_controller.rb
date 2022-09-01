class RegimensController < MyplaceonlineController
  
  def show
    @items = @obj.unfinished_items
    if @items.length == 0
      @nocontent = true
    end
    super
  end
  
  def reset
    set_obj
    
    @obj.reset
    
    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.regimens.reset_complete") }
    )
  end
  
  def footer_items_show
    result = super

    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.regimens.reset"),
        link: regimen_reset_path(@obj),
        icon: "recycle"
      }
    end

    return result
  end

  def complete_item
    set_obj
    
    result = {
      result: false
    }
    item_id = params[:item_id]
    if !item_id.blank?
      @obj.regimen_items[@obj.regimen_items.to_a.index{|i| i.id == item_id.to_i}].touch
      result[:result] = true
    end
    render json: result
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.regimens.regimen_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(regimens.regimen_name)"]
    end

    def obj_params
      params.require(:regimen).permit(
        :regimen_name,
        :notes,
        :regimen_type,
        regimen_items_attributes: RegimenItem.params,
      )
    end
end
