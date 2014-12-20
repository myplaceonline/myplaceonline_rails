class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check
  
  # By default, authentication is required for all actions except net/create/cancel
  
  # before_filter :configure_sign_up_params, only: [:create]
  # before_filter :configure_account_update_params, only: [:update]
  prepend_before_filter :authenticate_scope!, only: [
    :edit, :update, :destroy, :changepassword, :changeemail, :resetpoints,
    :advanced, :deletecategory, :security, :export
  ]
  
  before_filter :configure_permitted_parameters
  
  def new
    if request.post?
      build_resource(sign_up_params)

      resource_saved = resource.save
      yield resource if block_given?
      if resource_saved
        if resource.active_for_authentication?
          set_flash_message :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          #respond_with resource, location: after_sign_up_path_for(resource)
          redirect_to after_sign_up_path_for(resource)
        else
          set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          #respond_with resource, location: after_inactive_sign_up_path_for(resource)
          redirect_to after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        if @validatable
          @minimum_password_length = resource_class.password_length.min
        end
        respond_with resource
      end
    else
      super
    end
  end

  def delete
  end
  
  def changepassword
    if request.get?
      render :changepassword
    else
      doUpdate(:changepassword)
    end
  end
  
  def changeemail
    if request.get?
      render :changeemail
    else
      doUpdate(:changeemail)
    end
  end
  
  def update
    doUpdate(:changepassword)
  end
    
  def doUpdate(redirect)
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    current_password = params[:user][:current_password]
    new_password = params[:user][:password]
    
    ActiveRecord::Base.transaction do
      resource_updated = update_resource(resource, account_update_params)
      yield resource if block_given?
      if resource_updated
        Myp.password_changed(self.resource, current_password, new_password)
        Myp.remember_password(session, new_password)
        if is_flashing_format?
          flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
          set_flash_message :notice, flash_key
        end
        sign_in resource_name, resource, bypass: true
        redirect_to edit_user_registration_path
      else
        clean_up_passwords resource
        render redirect
      end
    end
  end
  
  def resetpoints
    if request.post?
      Myp.reset_points(current_user)
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.resetpointssuccess") }
    else
      render :resetpoints
    end
  end

  def advanced
  end

  def deletecategory
    
    passwords = I18n.t("myplaceonline.passwords.title")
    @categories = [passwords]
    
    if request.post?
      
      count = 0
      @category = params[:category]
      
      if @category.to_s.empty?
        flash[:error] = I18n.t("myplaceonline.users.delete_category_missing")
        render :deletecategory
      else
        
        if @category.eql? passwords
          ActiveRecord::Base.transaction do
            destroyed = Password.destroy_all(identity: current_user.primary_identity)
            count = destroyed.length
            if count > 0
              Myp.modify_points(current_user, :passwords, -1 * count)
            end
          end
        else
          raise "TODO"
        end
        
        redirect_to users_advanced_path,
          :flash => { :notice =>
                      I18n.t("myplaceonline.users.deleted_category_items",
                            :count => count, :category => @category)
                    }
      end
    else
      render :deletecategory
    end
  end

  def security
    @encrypt_by_default = current_user.encrypt_by_default
    if request.post?
      @encrypt_by_default = params[:encrypt_by_default]
      current_user.encrypt_by_default = @encrypt_by_default
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.security_settings_saved") }
    else
      render :security
    end
  end
  
  def export
    if request.format == "text/javascript"
      @jscontent = JSON.pretty_generate(exported_json)
    else
      # http://superuser.com/questions/633715/how-do-i-fix-warning-message-was-not-integrity-protected-when-using-gpg-symme
      @encrypt = current_user.encrypt_by_default
      @download = nil
      if !params[:encrypt].nil?
        @encrypt = params[:encrypt] == "1"
      end
      if request.post?
        @download = users_export_path(:download => "1", :encrypt => @encrypt ? "1" : "0")
      elsif !params[:download].nil?
        return send_data(
          JSON.pretty_generate(exported_json),
          :type => :json,
          :filename => "myplaceonline_export_" + DateTime.now.strftime("%Y%m%d-%H%M%S%z") + ".json",
          :disposition => 'attachment'
        )
      end
    end
    render :export
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end
  
  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:invite_code)
  end
  
  def after_sign_up_path_for(resource)
    '/'
  end
  
  def after_inactive_sign_up_path_for(resource)
    '/'
  end

  # You can put the params you want to permit in the empty array.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  
  def exported_json
    initialCategoryList = Myp.categories_for_current_user(current_user, nil, true)
    {
      "user" => current_user.as_json,
      "categories" => initialCategoryList.map{|x| x.as_json}
    }
  end
end
