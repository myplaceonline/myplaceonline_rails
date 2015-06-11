class GraphController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:display]

  def display
    categories = Myp.categories
    @sources = categories.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
    series_numbers = params.delete_if{|k,v| !k.start_with?("series_") || !k.end_with?("_source") }.to_a.map{|x| x[0][x[0].index('_')+1..x[0].rindex('_')-1].to_i}.sort
    data = Hash.new
    series_numbers.each do |series_number|
      series_index = series_number - 1
      source = params["series_" + series_number.to_s + "_source"]
      found_source = categories.find{|k,v| I18n.t("myplaceonline.category." + v.name) == source}
      if !found_source.nil?
        source_category = found_source[1]
        category_class = Object.const_get(source.singularize)
        category_class.where(
          identity_id: current_user.primary_identity.id
        ).each do |record|
          x_axis = record.updated_at
          y_value = 1
          series_array = data[x_axis]
          if series_array.nil?
            series_array = Array.new
            data[x_axis] = series_array
          end
          series_array[series_index] = y_value
        end
      end
    end
    
    if data.length > 0
      @graphdata = "Time,Y"
      data.to_a.sort{ |x,y| x[0] <=> y[0] }.each do |datum|
        @graphdata += "\n" + Myp.display_time(datum[0], User.current_user, :dygraph)
        series_numbers.each do |series_number|
          y_value = datum[1][series_number - 1]
          @graphdata += "," 
          if !y_value.nil?
            @graphdata += y_value.to_s
          else
            @graphdata += "0"
          end
        end
      end
    end
  end
end
