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
  prepend_before_action :authenticate_scope!, only: [
    :edit, :update, :destroy, :changepassword, :changeemail, :resetpoints,
    :advanced, :deletecategory, :security, :export, :appearance, :clipboard,
    :homepage, :diagnostics, :notifications
  ]
  
  before_action :configure_permitted_parameters
  
  def new
    @agree_terms = params[:agree_terms]
    @tz = params[:tz]
    if request.post?
      build_resource(sign_up_params)
      if !@tz.blank?
        t = ActiveSupport::TimeZone[@tz]
        if !t.nil?
          resource.timezone = t.name
        else
          # Default to Pacific Time
          #resource.timezone = "America/Los_Angeles"
        end
      end
      
      Rails.logger.info{"new resource: #{resource.inspect}"}
      
      if @agree_terms == "true"
        resource_saved = resource.save
        yield resource if block_given?
        if resource_saved
          
          flash.clear
          
          Myp.persist_password(params[:user][:password])
          
          Myp.send_support_email_safe("New User #{resource.email}", "New User #{resource.email}")
          
          if resource.active_for_authentication?
            #set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            #respond_with resource, location: after_sign_up_path_for(resource)
            redirect_to after_sign_up_path_for(resource),
              :flash => { :notice => I18n.t("myplaceonline.users.welcome") }
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            #respond_with resource, location: after_inactive_sign_up_path_for(resource)
            redirect_to after_inactive_sign_up_path_for(resource),
              :flash => { :notice => I18n.t("myplaceonline.users.welcome") }
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
    
    ApplicationRecord.transaction do
      resource_updated = update_resource(resource, account_update_params)
      yield resource if block_given?
      if resource_updated
        Myp.password_changed(self.resource, current_password, new_password)
        Myp.persist_password(new_password)
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
    check_password

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
    check_password

    passwords = I18n.t("myplaceonline.category.passwords")
    
    @categories = Myp.get_category_list
    
    if request.post?
      
      count = 0
      @category = params[:category]
      
      if @category.to_s.empty?
        flash[:error] = I18n.t("myplaceonline.users.delete_category_missing")
        render :deletecategory
      else
        foundcat = @categories.find{|c| c == @category}
        if !foundcat.nil?
          cl = Object.const_get(@category.singularize)
          ApplicationRecord.transaction do
            destroyed = cl.destroy_all(identity: current_user.primary_identity)
            count = destroyed.length
            if count > 0 && foundcat[0] != "foods" && foundcat[0] != "drinks"
              Myp.modify_points(current_user, cl.name.downcase.pluralize, -1 * count, session)
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
    check_password
    @encrypt_by_default = current_user.encrypt_by_default
    @minimize_password_checks = current_user.minimize_password_checks
    @encryption_mode = current_user.encryption_mode
    if request.post?
      @encrypt_by_default = params[:encrypt_by_default]
      @minimize_password_checks = params[:minimize_password_checks]
      @encryption_mode = params[:encryption_mode]
      current_user.encrypt_by_default = @encrypt_by_default
      current_user.minimize_password_checks = @minimize_password_checks
      current_user.encryption_mode = @encryption_mode
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.security_settings_saved") }
    else
      render :security
    end
  end
  
  def categories
    check_password
    @explicit_categories = current_user.explicit_categories
    @experimental_categories = current_user.experimental_categories
    @items_per_page = current_user.items_per_page
    @allow_adding_existing_file = current_user.allow_adding_existing_file
    if request.post?
      @explicit_categories = params[:explicit_categories]
      @experimental_categories = params[:experimental_categories]
      @items_per_page = params[:items_per_page]
      @allow_adding_existing_file = params[:allow_adding_existing_file]
      current_user.explicit_categories = @explicit_categories
      current_user.experimental_categories = @experimental_categories
      current_user.items_per_page = @items_per_page
      current_user.allow_adding_existing_file = @allow_adding_existing_file
      current_user.save!
      redirect_to users_advanced_path,
        :flash => { :notice => I18n.t("myplaceonline.general.saved") }
    else
      render :categories
    end
  end
  
  def sounds
    check_password

    @enable_sounds = current_user.enable_sounds
    if request.post?
      @enable_sounds = params[:enable_sounds]
      current_user.enable_sounds = @enable_sounds
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.general.saved") }
    else
      render :sounds
    end
  end
  
  def appearance
    check_password
    @page_transition = current_user.page_transition
    @always_autofocus = current_user.always_autofocus
    @show_timestamps = current_user.show_timestamps
    @top_left_icon = current_user.top_left_icon
    @recently_visited_categories = current_user.recently_visited_categories
    @most_visited_categories = current_user.most_visited_categories
    @most_visited_items = current_user.most_visited_items
    @after_new_item = current_user.after_new_item
    if request.post?
      @page_transition = params[:page_transition]
      @always_autofocus = params[:always_autofocus]
      @show_timestamps = params[:show_timestamps]
      @top_left_icon = params[:top_left_icon]
      @recently_visited_categories = params[:recently_visited_categories]
      @after_new_item = params[:after_new_item]

      if !@recently_visited_categories.blank?
        @recently_visited_categories = @recently_visited_categories.to_i
        if @recently_visited_categories > MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
          @recently_visited_categories = MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
        end
        if @recently_visited_categories < 0
          @recently_visited_categories = nil
        end
      end
      @most_visited_categories = params[:most_visited_categories]
      if !@most_visited_categories.blank?
        @most_visited_categories = @most_visited_categories.to_i
        if @most_visited_categories > MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
          @most_visited_categories = MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
        end
        if @most_visited_categories < 0
          @most_visited_categories = nil
        end
      end
      @most_visited_items = params[:most_visited_items]
      if !@most_visited_items.blank?
        @most_visited_items = @most_visited_items.to_i
        if @most_visited_items > MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
          @most_visited_items = MyplaceonlineQuickCategoryDisplaysController::ABSOLUTE_MAXIMUM
        end
        if @most_visited_items < 0
          @most_visited_items = nil
        end
      end
      current_user.page_transition = @page_transition
      current_user.always_autofocus = @always_autofocus
      current_user.show_timestamps = @show_timestamps
      current_user.top_left_icon = @top_left_icon
      current_user.recently_visited_categories = @recently_visited_categories
      current_user.most_visited_categories = @most_visited_categories
      current_user.most_visited_items = @most_visited_items
      current_user.after_new_item = @after_new_item
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.appearance_saved") }
    else
      render :appearance
    end
  end
  
  def notifications
    check_password
    @mobile = current_user.primary_identity.first_mobile_number
    if !@mobile.nil?
      @mobile = @mobile.number
    end
    @original_mobile = @mobile
    suppressions = current_user.suppressions
    if current_user.suppresses(User::SUPPRESSION_MOBILE)
      @notifications_mobile_suppress_reminder = true
    end
    if !params[:commit].blank?
      @mobile = params[:mobile]
      @notifications_mobile_suppress_reminder = params[:notifications_mobile_suppress_reminder]
      if @notifications_mobile_suppress_reminder
        suppressions |= User::SUPPRESSION_MOBILE
      else
        suppressions &= ~User::SUPPRESSION_MOBILE
      end
      current_user.suppressions = suppressions
      if !@mobile.blank?
        if @original_mobile.blank?
          current_user.primary_identity.identity_phones << IdentityPhone.new(
            number: @mobile,
            phone_type: IdentityPhone::PHONE_TYPE_CELL,
            parent_identity: current_user.primary_identity
          )
        else
          identity_phone = current_user.primary_identity.identity_phones[current_user.primary_identity.identity_phones.to_a.index{|x| x.number == @original_mobile}]
          identity_phone.number = @mobile
        end
      else
        if !@original_mobile.blank?
          identity_phone = current_user.primary_identity.identity_phones[current_user.primary_identity.identity_phones.to_a.index{|x| x.number == @original_mobile}]
          current_user.primary_identity.identity_phones.delete(identity_phone)
        end
      end
      current_user.primary_identity.save!
      current_user.save!
      redirect_to(
        params[:from_homepage].blank? ? users_notifications_path : root_path,
        :flash => { :notice => I18n.t("myplaceonline.users.notifications_saved") }
      )
    else
      render :notifications
    end
  end
  
  def homepage
    check_password
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
    check_password
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
  
  def diagnostics
    check_password
    @always_enable_debug = current_user.always_enable_debug
    @show_server_name = current_user.show_server_name
    if request.post?
      @always_enable_debug = params[:always_enable_debug]
      @show_server_name = params[:show_server_name]
      current_user.always_enable_debug = @always_enable_debug
      current_user.show_server_name = @show_server_name
      current_user.save!
      redirect_to edit_user_registration_path,
        :flash => { :notice => I18n.t("myplaceonline.users.diagnostics_settings_saved") }
    else
      render :diagnostics
    end
  end
  
  def changetimezone
    check_password
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
    check_password
    @encrypt = current_user.encrypt_by_default
    Rails.logger.debug{"setting default encrypt to #{@encrypt}"}
    if !params[:encrypt].nil?
      @encrypt = params[:encrypt] == "1" || params[:encrypt] == "true"
      Rails.logger.debug{"submitted encrypt setting of #{@encrypt}"}
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
    check_password
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:invite_code])
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
      password = check_password

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

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: level)
  end
end
