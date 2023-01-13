class CrontabsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:maxdblockid]

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.crontabs.maxdblockid"),
        link: crontabs_maxdblockid_path,
        icon: "info"
      },
    ]
  end
  
  def instance_page
    set_obj
    
    @details = @obj.display

    if request.post?
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.test_objects.updated") }
      )
    end
  end

  def maxdblockid
    @maxid = ApplicationRecord.connection.execute("select COALESCE(MAX(dblocker),0) as maxid from crontabs").map{|row| row["maxid"] }[0]
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.crontabs.crontab_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["crontabs.crontab_name"]
    end

    def obj_params
      params.require(:crontab).permit(
        :crontab_name,
        :dblocker,
        :run_class,
        :run_method,
        :minutes,
        :last_success,
        :run_data,
        :notes,
        :disabled,
      )
    end
end
