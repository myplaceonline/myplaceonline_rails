class MeadowsController < MyplaceonlineController
  def index
    @not_visited = params[:not_visited]
    if !@not_visited.blank?
      @not_visited = @not_visited.to_bool
    end
    super
  end

  def search_index_name
    Location.table_name
  end

  def search_parent_category
    category_name.singularize
  end
  
  def index_filters
    super + [
      {
        :name => :not_visited,
        :display => "myplaceonline.meadows.not_visited"
      }
    ]
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:meadow).permit(
        :notes,
        :visited,
        :rating,
        location_attributes: LocationsController.param_names
      )
    end

    def all_additional_sql(strict)
      if @not_visited && !strict
        "and (visited is null or visited = false)"
      else
        nil
      end
    end

    def default_sort_columns
      [Location.sorts]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.locations.name"), default_sort_columns[0]]
      ]
    end

    def all_joins
      "INNER JOIN locations ON locations.id = meadows.location_id"
    end

    def all_includes
      :location
    end
end
