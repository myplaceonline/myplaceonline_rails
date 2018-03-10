class MeadowsController < MyplaceonlineController
  def index
    @not_visited = params[:not_visited]
    if !@not_visited.blank?
      @not_visited = @not_visited.to_bool
    end
    super
  end

  def search_index_name
    Trek.table_name
  end

  def search_parent_category
    category_name.singularize
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
        trek_attributes: Trek.param_names
      )
    end

    def show_map?
      true
    end

    def simple_index_filters
      [
        { name: :not_visited, column: :visited, inverted: true },
      ]
    end
end
