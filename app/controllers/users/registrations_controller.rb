require "openssl"
require "digest/sha2"
require "open3"
require "tempfile"

class Users::RegistrationsController < Devise::RegistrationsController
  
  @@OPENSSL_MAGIC = "Salted__"
  @@OPENSSL_DEFAULT_CIPHER = "aes-256-cbc"
  @@OPENPGP_DEFAULT_CIPHER = "AES256"
  @@DEFAULT_MD = OpenSSL::Digest::SHA512
  
  skip_authorization_check
  
  # By default, authentication is required for all actions except new/create/cancel
  
  # before_filter :configure_sign_up_params, only: [:create]
  # before_filter :configure_account_update_params, only: [:update]
  prepend_before_filter :authenticate_scope!, only: [
    :edit, :update, :destroy, :changepassword, :changeemail, :resetpoints,
    :advanced, :deletecategory, :security, :export, :appearance, :clipboard,
    :homepage
  ]
  
  before_filter :configure_permitted_parameters
  
  def new
    @agree_terms = params[:agree_terms]
    if request.post?
      build_resource(sign_up_params)
      
      if @agree_terms == "1"
        resource_saved = resource.save
        yield resource if block_given?
        if resource_saved
          
          Myp.remember_password(session, params[:user][:password])
          
          if resource.active_for_authentication?
            #set_flash_message :notice, :signed_up if is_flashing_format?
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
        flash[:error] = t("myplaceonline.users.must_agree_terms", :terms => t("myplaceonline.info.terms"))
        clean_up_passwords resource
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
    Myp.ensure_encryption_key(session)
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
    Myp.ensure_encryption_key(session)
    passwords = I18n.t("myplaceonline.category.passwords")
    
    search = Myp.categories(User.current_user).merge({
      "foods" => Category.new(name: "foods"),
      "drinks" => Category.new(name: "drinks"),
    })
    
    @categories = search.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
    
    if request.post?
      
      count = 0
      @category = params[:category]
      
      if @category.to_s.empty?
        flash[:error] = I18n.t("myplaceonline.users.delete_category_missing")
        render :deletecategory
      else
        
        foundcat = search.find{|k,v| I18n.t("myplaceonline.category." + v.name) == @category}
        if !foundcat.nil?
          cl = Object.const_get(@category.singularize)
          ActiveRecord::Base.transaction do
            destroyed = cl.destroy_all(owner: current_user.primary_identity)
            count = destroyed.length
            if count > 0 && foundcat[0] != "foods" && foundcat[0] != "drinks"
              Myp.modify_points(current_user, foundcat[1].name.to_sym, -1 * count, session)
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
    Myp.ensure_encryption_key(session)
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
  
  def categories
    Myp.ensure_encryption_key(session)
    @explicit_categories = current_user.explicit_categories
    if request.post?
      @explicit_categories = params[:explicit_categories]
      current_user.explicit_categories = @explicit_categories
      current_user.save!
      redirect_to users_advanced_path,
        :flash => { :notice => I18n.t("myplaceonline.general.saved") }
    else
      render :categories
    end
  end
  
  def sounds
    Myp.ensure_encryption_key(session)
    @disable_sounds = current_user.disable_sounds
    if request.post?
      @disable_sounds = params[:disable_sounds]
      current_user.disable_sounds = @disable_sounds
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.general.saved") }
    else
      render :sounds
    end
  end
  
  def appearance
    Myp.ensure_encryption_key(session)
    @page_transition = current_user.page_transition
    if request.post?
      @page_transition = params[:page_transition]
      current_user.page_transition = @page_transition
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.appearance_saved") }
    else
      render :appearance
    end
  end
  
  def homepage
    Myp.ensure_encryption_key(session)
    @obj = User.current_user.primary_identity
    if request.patch?
      @obj.assign_attributes(
        params.require(:identity).permit(
          myplets_attributes: [
            :id,
            :_destroy,
            :title,
            :category_name,
            :category_id,
            :y_coordinate,
            :x_coordinate,
            :border_type
          ]
        )
      )
      if @obj.save
        redirect_to users_advanced_path,
          :flash => { :notice => I18n.t("myplaceonline.users.homepage_saved") }
      else
        render :homepage
      end
    else
      render :homepage
    end
  end
  
  def clipboard
    Myp.ensure_encryption_key(session)
    @clipboard_integration = current_user.clipboard_integration
    @clipboard_transform_numbers = current_user.clipboard_transform_numbers
    if request.post?
      @clipboard_integration = params[:clipboard_integration]
      @clipboard_transform_numbers = params[:clipboard_transform_numbers]
      current_user.clipboard_integration = @clipboard_integration
      current_user.clipboard_transform_numbers = @clipboard_transform_numbers
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.clipboard_settings_saved") }
    else
      render :clipboard
    end
  end
  
  def changetimezone
    Myp.ensure_encryption_key(session)
    if request.post?
      current_user.timezone = params[:user][:timezone]
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.timezone_settings_saved") }
    else
      render :changetimezone
    end
  end
  
  def export
    Myp.ensure_encryption_key(session)
    @encrypt = current_user.encrypt_by_default
    if !params[:encrypt].nil?
      @encrypt = params[:encrypt] == "1" || params[:encrypt] == "true"
    end
    filename = "myplaceonline_export_" + DateTime.now.strftime("%Y%m%d-%H%M%S%z") + ".json"
    if @encrypt
      # The page that shows this example command will be a different request
      # from the actual download, so the filename might not be the same

      filename += ".pgp"
      @command = "gpg --output decrypted.json --decrypt myplaceonline_export_*.json.pgp"

      #filename += ".encrypted"
      #@command = "openssl enc -d -#{@@OPENSSL_DEFAULT_CIPHER} -md #{@@DEFAULT_MD.new.name.downcase} -in file.encrypted"
    end
    if request.format == "text/javascript" || request.format == "application/json"
      @jscontent = exported_json(@encrypt, true)
      if !params[:download].nil?
        return send_data(
          @jscontent,
          :type => :json,
          :filename => filename,
          :disposition => 'attachment'
        )
      end
    else
      @download = nil
      if request.post?
        @download = users_export_path(:download => "1", :encrypt => @encrypt ? "1" : "0")
      elsif !params[:download].nil?
        return send_data(
          exported_json(@encrypt, true),
          :type => :json,
          :filename => filename,
          :disposition => 'attachment'
        )
      end
    end
    render :export
  end

  def offline
    Myp.ensure_encryption_key(session)
    @encrypt = false
    if request.post?
      @data = exported_json(@encrypt, false)
    end
    render :offline
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
  
  def exported_json(encrypt, pretty)
    initialCategoryList = Myp.categories_for_current_user(current_user, nil, true)
    result = {
      "time" => DateTime.now,
      "categories" => initialCategoryList.map{|x| x.as_json},
      "user" => current_user.as_json
    }
    if pretty
      result = JSON.pretty_generate(result)
    else
      result = result.to_json
    end
    if encrypt
      password = Myp.ensure_encryption_key(session)

      result = encrypt_for_pgp(password, result)

      #result = encrypt_for_openssl(password, result)
    end
    result
  end
  
  # Return symmetrically encrypted bytes in RFC 4880 format which can be
  # read by GnuPG or PGP. For example:
  # $ gpg --decrypt file.pgp
  #
  # ruby-gpgme doesn't seem to work: https://github.com/ueno/ruby-gpgme/issues/11
  # openpgp doesn't seem to work: https://github.com/bendiken/openpgp/issues/2
  # Therefore we assume gpg is installed and try to spawn out to it
  def encrypt_for_pgp(
    password,
    data,
    cipher = @@OPENPGP_DEFAULT_CIPHER,
    md = @@DEFAULT_MD.new
  )
    input_file = Tempfile.new('input')
    begin
      input_file.write(data)
      input_file.close
      output_file = Tempfile.new('output')
      begin
        gpgbin = "/usr/bin/gpg"
        command = "#{gpgbin} --batch --passphrase-fd 0 --yes --homedir /tmp " +
          "--no-use-agent --s2k-mode 3 --s2k-count 65536 " +
          "--force-mdc --cipher-algo #{cipher} --s2k-digest-algo #{md.name} " +
          "-o #{output_file.path} --symmetric #{input_file.path}"
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          stdin.write(password)
          stdin.close_write
          exit_status = wait_thr.value
          if exit_status != 0
            raise "Exit status " + exit_status.to_s
          end
        end
        output_file.close
        return IO.binread(output_file.path)
      ensure
        output_file.unlink
      end
    ensure
      input_file.unlink
    end
  end

  # http://stackoverflow.com/a/27651940/4135310
  #
  # Note: OpenSSL "enc" uses a non-standard file format with a custom key
  # derivation function and a fixed iteration count of 1, which some consider
  # less secure than alternatives such as OpenPGP/GnuPG
  #
  # Resulting bytes when written to #{FILE} may be decrypted from the command
  # line with `openssl enc -d -#{cipher} -md #{md} -in #{FILE}`
  #
  # Example:
  #  openssl enc -d -aes-256-cbc -md sha256 -in file.encrypted
  def encrypt_for_openssl(
    password,
    data,
    cipher = @@OPENSSL_DEFAULT_CIPHER,
    md = @@DEFAULT_MD.new
  )
    salt = SecureRandom.random_bytes(8)
    cipher = OpenSSL::Cipher::Cipher.new(cipher)
    cipher.encrypt
    cipher.pkcs5_keyivgen(password, salt, 1, md)
    encrypted_data = cipher.update(data) + cipher.final
    @@OPENSSL_MAGIC + salt + encrypted_data
  end
  
  # Data may be written from the command line with
  # `openssl enc -#{cipher} -md #{md} -in #{INFILE} -out #{OUTFILE}`
  # and the resulting bytes may be read by this function.
  #
  # Example:
  #  openssl enc -aes-256-cbc -md sha256 -in file.txt -out file.txt.encrypted
  def decrypt_from_openssl(
    password,
    data,
    cipher = @@OPENSSL_DEFAULT_CIPHER,
    md = @@DEFAULT_MD.new
  )
    input_magic = data.slice!(0, 8)
    input_salt = data.slice!(0, 8)
    cipher = OpenSSL::Cipher::Cipher.new(cipher)
    cipher.decrypt
    cipher.pkcs5_keyivgen(password, input_salt, 1, md)
    c.update(data) + c.final
  end
end
