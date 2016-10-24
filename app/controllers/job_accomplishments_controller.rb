class JobAccomplishmentsController < MyplaceonlineController
  def path_name
    "job_job_accomplishment"
  end

  def form_path
    "job_accomplishments/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.job_accomplishments.job'),
        link: job_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.job_accomplishments.job'),
        link: job_path(@obj.job),
        icon: "back"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["job_accomplishments.accomplishment_time DESC"]
    end

    def obj_params
      params.require(:job_accomplishment).permit(
        :accomplishment_title,
        :accomplishment,
        :accomplishment_time
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Job
    end
end
