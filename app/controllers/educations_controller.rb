class EducationsController < MyplaceonlineController
  def index
    @graduated = param_bool(:graduated)
    super
  end
  
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.education_end, User.current_user)
  end
    
  def index_filters
    super +
    [
      {
        :name => :graduated,
        :display => "myplaceonline.educations.graduated"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.educations.education_end"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["educations.education_end"]
    end

    def obj_params
      params.require(:education).permit(
        :education_name,
        :education_start,
        :education_end,
        :degree_name,
        :degree_type,
        :student_id,
        :is_graduated,
        :gpa,
        :notes,
        location_attributes: LocationsController.param_names,
        education_files_attributes: FilesController.multi_param_names
      )
    end

    def all_additional_sql(strict)
      result = super(strict)
      if !strict && @graduated
        if result.nil?
          result = ""
        end
        result += " and #{model.table_name}.graduated is not null"
      end
      result
    end
end
