class GraphController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:display, :source_values]

  def display
    if params[:hideform].is_true?
      @hideform = true
    end
    categories = Myp.categories(User.current_user)
    @values = get_values()
    @sources = categories.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
    series_numbers = params.dup.permit!.to_hash.delete_if{|k,v| !k.start_with?("series_") || !k.end_with?("_source") }.to_a.map{|x| x[0][x[0].index('_')+1..x[0].rindex('_')-1].to_i}.sort
    data = Hash.new
    @selected_sources = Hash.new
    @selected_values = Hash.new
    @selected_xvalues = Hash.new
    series_numbers.each do |series_number|
      series_index = series_number - 1
      source = params["series_" + series_number.to_s + "_source"]
      value_name = params["series_" + series_number.to_s + "_values"]
      xvalue_name = params["series_" + series_number.to_s + "_xvalues"]
      Rails.logger.debug{"graph display source: #{source}, value_name: #{value_name}, xvalue_name: #{xvalue_name}"}
      if !source.blank?
        category_class = Object.const_get(source.singularize.gsub(" ", ""))
        if xvalue_name.blank?
          xvalue_name = "updated_at"
        end

        @values = get_values(source)
        @selected_sources[series_number] = source
        @selected_values[series_number] = value_name
        @selected_xvalues[series_number] = xvalue_name
        
        category_class.where(
          identity_id: current_user.current_identity.id
        ).each do |record|
          x_axis = record.send(xvalue_name)
          y_value = 1
          if !value_name.blank?
            y_value = record.send(value_name)
          end
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
  
  def source_values
    @values = get_values(params[:source])
    render :layout => false
  end
  
  protected
  
    def get_values(source = nil)
      result = []
      if !source.blank?
        category_class = Object.const_get(source.singularize.gsub(" ", ""))
        result += category_class.attribute_names
      end
      result
    end
end
