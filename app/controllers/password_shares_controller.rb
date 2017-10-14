class PasswordSharesController < MyplaceonlineController
  
  def transfer
    set_obj
    
    ApplicationRecord.transaction do
      new_password = @obj.password.dup
      new_password.identity = User.current_user.current_identity
      if new_password.password_encrypted?
        new_password.encrypt = true
        new_password.password_encrypted = nil
      end
      new_password.visit_count = 0
      new_password.password = @obj.unencrypted_password
      
      @obj.password_secret_shares.each do |password_secret_share|
        dup_secret = password_secret_share.password_secret.dup
        dup_secret.identity = new_password.identity
        if dup_secret.answer_encrypted?
          dup_secret.encrypt = true
          dup_secret.answer_encrypted = nil
        end
        dup_secret.answer = password_secret_share.unencrypted_answer
        new_password.password_secrets << dup_secret
      end

      new_password.save!

      @obj.destroy!

      return redirect_to password_path(new_password),
                :flash => { :notice =>
                  I18n.t("myplaceonline.passwords.transfer_success")
                }
    end
  end
  
  protected
    def obj_params
      params.require(:password_share).permit(
        :_destroy
      )
    end

    def has_category
      false
    end
    
    def handle_object_not_found(id)
      raise Myp::SuddenRedirectError.new(root_path, I18n.t("myplaceonline.password_shares.not_found"))
    end
end
