class PermissionSharesController < MyplaceonlineController
  def personalize
    set_obj
    
    if !request.patch?
      
      if @obj.email.personalize
        @obj.email.all_targets.each do |email, contact|
          @obj.email.email_personalizations.build({target: email, do_send: true, contact: contact})
        end
      else
        after_save
      end
    else
      @obj.update_attributes(params.require(:permission_share).permit(
        email_attributes: EmailsController.param_names
      ))
      if @obj.save
        after_save
      end
    end
  end
  
  protected
  
    def after_save
      if @obj.async?
        ApplicationJob.perform(ShareJob, @obj)

        redirect_to @obj.simple_path,
          :flash => { :notice =>
                      I18n.t("myplaceonline.permissions.shared_sucess_async")
                    }
      else
        @obj.execute_share

        redirect_to @obj.simple_path,
          :flash => { :notice =>
                      I18n.t("myplaceonline.permissions.shared_sucess")
                    }
      end
    end
  
    def has_category
      false
    end
    
    def sorts
      ["permission_shares.updated_at DESC"]
    end

    def obj_params
      params.require(:permission_share).permit(
        :trash
      )
    end
end
