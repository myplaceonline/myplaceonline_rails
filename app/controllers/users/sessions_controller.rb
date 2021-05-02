class Users::SessionsController < Devise::SessionsController
  skip_authorization_check
  # before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    self.resource.email = session[:login_email]
    self.resource.remember_me = true
    @redirect = nil
    if !params[:redirect].blank?
      @redirect = URI.parse(CGI.unescape(params[:redirect])).to_s
    end
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create
    if !params[:user].nil?
      # If login fails, warden.authenticate! will throw a 401, so 
      # there's no simple way to save off the email address, so we'll
      # just throw it in the session for the `new` call above to pick it up
      # on the redirect
      session[:login_email] = params[:user][:email]
    end
    self.resource = warden.authenticate!(auth_options)
    
    # If we make it here, the login is succesful
    session[:login_email] = nil
    Myp.persist_password(params[:user][:password])
    
    #set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    
    if resource.needs_identity?
      resource.check_invite_code(Myp.website_domain, true)
    end
    
    yield resource if block_given?
    if params[:redirect].blank?
      logged_in_path = after_sign_in_path_for(resource)
    else
      logged_in_path = URI.parse(CGI.unescape(params[:redirect])).to_s
    end
    respond_with resource, location: logged_in_path
  end
  
  def reenter
    if !user_signed_in?
      return redirect_to "/users/sign_in"
    end
    
    @redirect = nil
    if params.has_key?(:redirect)
      @redirect = URI.parse(CGI.unescape(params[:redirect].scrub)).to_s
    end
    
    if !session[:password].blank? && current_user.valid_password?(session[:password])
      return redirect_to @redirect.nil? ? "/" : @redirect
    end
    
    if request.post?
      pwd = params[:password]
      if current_user.valid_password?(pwd)
        Myp.persist_password(pwd)
        return redirect_to @redirect.nil? ? "/" : @redirect
      else
        flash.now[:error] = I18n.t("myplaceonline.errors.invalidpassword")
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    MyplaceonlineExecutionContext.persistent_user_store.clear
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    #set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    
    # See ApplicationController.after_sign_out_path_for
    respond_to_on_destroy
  end
  
  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
