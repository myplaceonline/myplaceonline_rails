class PermissionSharesController < MyplaceonlineController
  def personalize
    set_obj
    
    if !request.patch?
      @obj.email.all_targets.each do |email, contact|
        @obj.email.email_personalizations.build({target: email, do_send: true, contact: contact})
      end
    else
      @obj.update_attributes(params.require(:permission_share).permit(
        email_attributes: EmailsController.param_names
      ))
      if @obj.save
        if @obj.async?
          ShareJob.perform_later(@obj)

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
    end
  end
  
  protected
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
