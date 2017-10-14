class PassportsController < MyplaceonlineController
  def may_upload
    true
  end

  def index
    @expired = params[:expired]
    if !@expired.blank?
      @expired = @expired.to_bool
    end
    super
  end

  def index_filters
    super + [
      {
        :name => :expired,
        :display => "myplaceonline.passports.expired"
      }
    ]
  end

  protected
    def all_additional_sql(strict)
      if (@expired.blank? || !@expired) && !strict
        "and (expires is null or expires > now())"
      else
        nil
      end
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.passports.region"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(passports.region)"]
    end

    def obj_params
      params.require(:passport).permit(
        :region,
        :passport_number,
        :expires,
        :issued,
        :issuing_authority,
        :name,
        :notes,
        passport_pictures_attributes: FilesController.multi_param_names
      )
    end
end
