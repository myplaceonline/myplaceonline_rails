# No pre-authorization on these API calls. Use `authorize! :edit, obj` if needed.
class ApiController < ApplicationController
  include Rails.application.routes.url_helpers

  skip_authorization_check

  # Only applies for POST methods (http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html#method-i-protect_from_forgery)
  skip_before_action :verify_authenticity_token, only: [
    :debug,
    :twilio_sms,
    :login_or_register,
    :refresh_token,
    :enter_invite_code,
    :add_identity,
    :change_identity,
    :delete_identity,
    :quickfeedback,
    :update_password,
    :update_email,
    :forgot_password,
    :update_settings,
    :set_child_file,
    :update_notification_settings,
  ]
  
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categories_for_current_user(current_user, nil, true) }
    end
  end
  
  def search
    display_category_prefix = Myp.param_bool(params, :display_category_prefix, default_value: true)
    display_category_icon = Myp.param_bool(params, :display_category_icon, default_value: true)
    search_filters_model_name = params[:search_filters_model]
    only_public = Myp.param_bool(params, :public, default_value: false)
    filters = {}
    if !search_filters_model_name.blank?
      search_filters_model = search_filters_model_name.constantize
      if search_filters_model.respond_to?("search_filters")
        filters = search_filters_model.search_filters
      end
    end
    response = Myp.full_text_search(
      current_user,
      params[:q],
      category: params[:category],
      parent_category: params[:parent_category],
      display_category_prefix: display_category_prefix,
      display_category_icon: display_category_icon,
      filters: filters,
      only_public: only_public,
    )
    respond_to do |format|
      format.json { render json: response }
    end
  end
  
  def randomString
    length = Myp::DEFAULT_PASSWORD_LENGTH
    if !params[:length].nil?
      length = params[:length].to_i
      if length <= 0 || length > 512
        length = Myp::DEFAULT_PASSWORD_LENGTH
      end
    end
    
    numbers = true
    special = true
    special_additional = true
    lowercase = true
    uppercase = true
    
    if !params[:special].blank?
      special = params[:special].to_bool
    end
    if !params[:special_additional].blank?
      special_additional = params[:special_additional].to_bool
    end
    if !params[:numbers].blank?
      numbers = params[:numbers].to_bool
    end
    if !params[:lowercase].blank?
      lowercase = params[:lowercase].to_bool
    end
    if !params[:uppercase].blank?
      uppercase = params[:uppercase].to_bool
    end
    
    possibilities = []
    if lowercase
      possibilities += Myp::POSSIBILITIES_LOWERCASE
    end
    if uppercase
      possibilities += Myp::POSSIBILITIES_UPPERCASE
    end
    if numbers
      possibilities += Myp::POSSIBILITIES_NUMERIC
    end
    if special
      possibilities += Myp::POSSIBILITIES_SPECIAL
    end
    if special_additional
      possibilities += Myp::POSSIBILITIES_SPECIAL_ADDITIONAL
    end
    
    result = (0...length).map { possibilities[SecureRandom.random_number(possibilities.length)] }.join
    
    if lowercase
      result[SecureRandom.random_number(result.length)] = Myp::POSSIBILITIES_LOWERCASE[SecureRandom.random_number(Myp::POSSIBILITIES_LOWERCASE.length)]
    end
    if uppercase
      result[SecureRandom.random_number(result.length)] = Myp::POSSIBILITIES_UPPERCASE[SecureRandom.random_number(Myp::POSSIBILITIES_UPPERCASE.length)]
    end
    if special
      result[SecureRandom.random_number(result.length)] = Myp::POSSIBILITIES_SPECIAL[SecureRandom.random_number(Myp::POSSIBILITIES_SPECIAL.length)]
    end
    if special_additional
      result[SecureRandom.random_number(result.length)] = Myp::POSSIBILITIES_SPECIAL_ADDITIONAL[SecureRandom.random_number(Myp::POSSIBILITIES_SPECIAL_ADDITIONAL.length)]
    end
    if numbers
      result[SecureRandom.random_number(result.length)] = Myp::POSSIBILITIES_NUMERIC[SecureRandom.random_number(Myp::POSSIBILITIES_NUMERIC.length)]
    end
    
    success = true
    details = nil
    
    if result.length == 0
      success = false
      details = "Please select some password generation options"
    end
    
    render json: {
      success: success,
      randomString: result,
      details: details,
    }
  end
  
  def subregions
    render partial: 'myplaceonline/subregionselect'
  end
  
  def renderpartial
    if !params[:partial].blank?
      if !params[:namePrefix].blank?
        updatedNamePrefix = params[:namePrefix][0..params[:namePrefix].rindex('[')-1]
        name = params[:namePrefix][params[:namePrefix].rindex('[')..-1].gsub("\[", "").gsub("\]", "")
        params[:namePrefix] = updatedNamePrefix
        params[:name] = name
        @params = params
        render(partial: 'myplaceonline/render_partial')
      else
        json_error("Name prefix not specified")
      end
    else
      json_error("Partial not specified")
    end
  end
  
  def quickfeedback
    if !current_user.nil? && !current_user.current_identity.nil?
      user_input = params[:user_input]
      begin
        
        params_massaged = Myp.debug_print(params.except(:user_input), plain: true)

        Myp.send_support_email_safe(
          "Quick Feedback",
          CGI::escapeHTML(user_input) + "\n\n<!-- " + CGI::escapeHTML(params_massaged).gsub("\n", "<br />\n") + " -->",
          user_input + "\n\n" + params_massaged,
          email: current_user.email,
          request: request,
          html_comment_details: true,
        )

        render json: {
          :result => true
        }
      rescue Exception => e
        render json: {
          :result => false,
          :error => e.to_s
        }
      end
    else
      render json: {
        :result => false,
        :error => I19n.t("myplaceonline.general.quick_feedback_none"),
      }
    end
  end
  
  def debug
    
    body_markdown = "Message: " + params[:message].to_s + "\n\n" + "Stack: " + params[:stack].to_s
    
    Myp.send_support_email_safe(
      "Application Error",
      Myp.markdown_to_html(body_markdown.gsub("\n", "<br />\n")).html_safe,
      body_markdown,
      request: request,
    )
    
    render json: {
      :result => true
    }
  end
  
  def distinct_values
    table_name = params[:table_name]
    if !table_name.blank?
      column_name = params[:column_name]
      if !column_name.blank?
        model = Object.const_get(table_name)
        if !model.nil?
          
          identity = User.current_user.current_identity_id
          if !params[:identity].blank? && params[:identity].to_i == User::SUPER_USER_IDENTITY_ID && model.allow_super_user_search?
            identity = User::SUPER_USER_IDENTITY_ID
          end
          
          if !model.column_names.index(column_name).nil?
            render json: model.find_by_sql(%{
              SELECT DISTINCT #{column_name}
              FROM #{model.table_name}
              WHERE identity_id = #{identity}
              ORDER BY #{column_name}
            }).map{|x| x.send(column_name) }.delete_if{|x| x.blank?}.map{|x|
              {
                title: x,
                #link: "#",
                #count: Integer,
                #filtertext: String,
                #icon: String
              }
            }
          else
            json_error("column_name invalid")
          end
        else
          json_error("table_name invalid")
        end
      else
        json_error("column_name not specified")
      end
    else
      json_error("table_name not specified")
    end
  end
  
  def sleep_time
    if !current_user.nil? && current_user.admin?
      duration = params[:duration]
      if duration.blank?
        duration = 1
      else
        duration = duration.to_f
      end
      sleep(duration)
      render json: {
        :result => true,
        :message => "Slept for #{duration} s"
      }
    else
      render json: {
        :result => false
      }
    end
  end
  
  def hello_world
    render json: {
      message: "Hello World"
    }
  end
  
  def newfile
    result = {
      :result => false
    }
    urlpath = params[:urlpath]
    
    Rails.logger.debug{"newfile urlpath: #{urlpath}"}
    
    # Adding a picture will save the parent item, but the user will usually
    # explicitly save the item after editing an item and adding one or more
    # pictures, so we don't want to handle updates on every save because that might
    # involve side effects like updating calendars
    MyplaceonlineExecutionContext.disable_handling_updates do
      if !urlpath.blank?
        spliturl = urlpath.split('/')
        if spliturl.length >= 3
          
          accumulatedSingularNamePrefix = ""

          objclass_index = 1
          
          # This upload may come from the root element or from a child form submission
          paramnode = nil
          while paramnode.nil?
            if spliturl[objclass_index].nil?
              objclass_index -= 2
              break
            end
            
            objclass = spliturl[objclass_index].singularize

            Rails.logger.debug{"objclass: #{objclass}"}
            
            accumulatedSingularNamePrefix = objclass

            paramnode = params[objclass]
            
            Rails.logger.debug{"checking paramnode: #{Myp.debug_print(paramnode)}"}
            
            if paramnode.nil?
              objclass_index += 2
            else
              paramnode = paramnode.dup.permit!.to_hash.with_indifferent_access
            end
          end

          objid = spliturl[objclass_index + 1]
          
          if !objid.index("?").nil?
            objid = objid[0..objid.index("?")-1]
          end
          
          Rails.logger.debug{"objclass: #{objclass}, objid: #{objid}"}
          
          if objid != "new"
            obj = Myp.find_existing_object(objclass, objid, false)
            authorize! :edit, obj

            # Alrighty, we've got the object and the user is authorized, so
            # now we can start the real work
            Rails.logger.debug{"obj existing: #{obj.inspect}"}
          else
            obj = nil
          end
          
          # We'll only have the file object, so just follow the path of params
          # for the object down to right above the file leaf node
          prevnode = obj
          prevkey = nil
          prevkey_full = nil
          newfilewrapper = nil

          Rails.logger.debug{"initial node: #{paramnode.inspect}"}
          
          keepgoing = !paramnode.nil?
          iterations = 0
          while keepgoing && iterations < 500 do
            pair = paramnode.to_a[0]
            key = pair[0]
            val = paramnode = pair[1]
            iterations = iterations + 1
            
            Rails.logger.debug{"key: #{key}, val: #{val}"}
            
            if key.end_with?("_attributes")
              key = key[0..key.index("_attributes")-1]
            end

            if val.has_key?("file") # Singular file upload (e.g. website domain favicon)
              Rails.logger.debug{"found identity_file_attributes key"}
              
              if val[:file].is_a?(ActionDispatch::Http::UploadedFile)
                newfile = IdentityFile.create!(val)
              else
                newfile = IdentityFile.create_for_path!(file_hash: val[:file])
              end
              
              if !prevnode.nil?
                prevnode.send("#{key}=", newfile)

                Rails.logger.debug{"saving: #{Myp.debug_print(prevnode)}"}

                prevnode.save!
              end
              
              keepgoing = false
              
              accumulatedSingularNamePrefix = accumulatedSingularNamePrefix + "[" + pair[0] + "]"
              
              result = create_newfile_result(newfile, params, singular: true, singularNamePrefix: accumulatedSingularNamePrefix)
              
              Rails.logger.debug{"breaking loop"}
            elsif !!(key =~ /\A[-+]?[0-9]+\z/) # Regex checking for only digits
              ikey = key.to_i
              
              # If the next child is identity_file_attributes, then we know
              # we're done
              if val.has_key?("identity_file_attributes")
                
                if prevkey_full.end_with?("_attributes")
                  
                  Rails.logger.debug{"prevkey: #{prevkey}"}
                  
                  if !obj.nil?
                    prevkeyclass = Object.const_get(prevkey.singularize.to_s.camelize)

                    newfilewrapper = prevkeyclass.new(val)
                    
                    prevnode.send(prevkey) << newfilewrapper

                    Rails.logger.debug{"saving: #{Myp.debug_print(prevnode)}"}

                    prevnode.save!

                    newfile = newfilewrapper.identity_file
                  else
                    
                    identity_file_attributes = val["identity_file_attributes"]
                    
                    if identity_file_attributes[:file].is_a?(ActionDispatch::Http::UploadedFile)
                      newfile = IdentityFile.create!(identity_file_attributes)
                    else
                      newfile = IdentityFile.create_for_path!(file_hash: identity_file_attributes[:file])
                    end
                  end

                  Rails.logger.debug{"newfile: #{Myp.debug_print(newfile)}"}
                else
                  raise "todo"
                end

                result = create_newfile_result(newfile, params, newfilewrapper: newfilewrapper)
                
                keepgoing = false

                Rails.logger.debug{"breaking loop"}
              else
                # Otherwise just index in
                prevnode = obj
                prevkey = key
                prevkey_full = pair[0]
                if !obj.nil?
                  obj = obj[ikey]
                  Rails.logger.debug{"nested indexed node: #{Myp.debug_print(obj)}"}
                end
              end
            else
              Rails.logger.debug{"outer else: #{Myp.debug_print(obj)}, key: #{key}"}
              
              prevnode = obj
              prevkey = key
              prevkey_full = pair[0]
              
              if !obj.nil?
                obj = obj.send(key)
                Rails.logger.debug{"nested node: #{Myp.debug_print(obj)}"}
              end
            end
          end
          if !result[:result]
            # Just a simple add of a file
            if !params[:identity_file].nil?
              if params[:identity_file][:file].is_a?(ActionDispatch::Http::UploadedFile)
                newfile = IdentityFile.create!(params.require(:identity_file).permit(FilesController.param_names))
              else
                newfile = IdentityFile.create_for_path!(file_hash: params[:identity_file][:file])
              end
              Rails.logger.debug{"newfile final: #{newfile.inspect}"}
              result = create_newfile_result(newfile, params, singular: true)
            end
          end
        end
      end
    end
    
    render json: result
  end
  
  # Testing:
  # curl --request POST -F "identity_file[file]=@file.jpg" -F "class=ParentClass" -F "id=1" "http://localhost:3000/api/set_child_file?security_token=${TOKEN}&emulate_host=${HOST}"
  def set_child_file
    result = {
      code: 500,
      identity_file_id: nil,
    }
    
    c = params[:class]
    if !c.blank?
      id = params[:id]
      if !id.blank?
        obj = Myp.find_existing_object(c, id, false)
        if !obj.nil?
          authorize! :edit, obj
          if !params[:identity_file].nil?
            ActiveRecord::Base.transaction do
              if params[:identity_file][:file].is_a?(ActionDispatch::Http::UploadedFile)
                newfile = IdentityFile.create!(params.require(:identity_file).permit(FilesController.param_names))
              else
                newfile = IdentityFile.create_for_path!(file_hash: params[:identity_file][:file])
              end
              obj.identity_file = newfile
              obj.save!

              result[:code] = 200
              result[:identity_file_id] = newfile.id
            end
          end
        end
      end
    end
    
    render(
      json: result,
      status: result[:code],
    )
  end
  
  def newitem
    redirect_to params[:newitemcategory] + "?prefill=" + params[:q]
  end
  
  def postal_code_search
    result = {
      result: false
    }
    q = params[:q]
    region = params[:region]
    if !q.blank? && q.length == 5 && !region.blank?
      zip_code = UsZipCode.where(zip_code: q).first
      if !zip_code.nil?
        result[:sub_region1] = zip_code.state
        result[:sub_region2] = zip_code.city
        result[:looked_up_postal_code] = I18n.t(
          "myplaceonline.locations.looked_up_postal_code",
          sub_region1: result[:sub_region1],
          sub_region2: result[:sub_region2],
          postal_code: q
        )
        result[:result] = true
      end
    end
    render json: result
  end

  def website_title
    result = {
      result: false
    }
    link = params[:link]
    if !Myp.valid_link?(link)
      result[:error] = I18n.t("myplaceonline.websites.invalid_link")
    else
      begin
        info = Myp.website_info(link)
        if !info.nil?
          if info[:title].blank?
            raise "Could not find title in link"
          end
          result[:title] = info[:title].force_encoding("utf-8")
          result[:link] = info[:link].force_encoding("utf-8")
          result[:result] = true
        else
          raise "Website returned no content"
        end
      rescue Exception => e
        Myp.warn("website_title error with URL: '#{link}'", e, request: request)
        result[:error] = e.to_s
      end
    end
    render json: result
  end
  
  # https://www.twilio.com/docs/api/twiml/sms/your_response
  # Test: curl -X POST "http://localhost:3000/api/twilio_sms?Body=a&From=+11234567890"
  #
  # The broad flow is as follows:
  #   User A (identity I1, phone number P1) sends a text message to identity I2 with phone number P2. This updates the
  #   LastTextMessage table with phone_number = P2, to_identity = I2, from_identity = I1. If P2 responds to
  #   myplaceonline with a text message (with phone number `from` = P2 below), we lookup phone_number = from in the
  #   LastTextMessage table and set context_identity_id to the to_identity. Next we proxy on the text message to the
  #   from_identity and upate the LastTextMessage table.
  def twilio_sms
    
    body = params["Body"]
    from = params["From"]
    
    # Parameters:
    # {
    #   "ToCountry"=>"US",
    #   "ToState"=>"CA",
    #   "SmsMessageSid"=>"SM5[...]",
    #   "NumMedia"=>"0",
    #   "ToCity"=>"SAN DIEGO",
    #   "FromZip"=>"92110",
    #   "SmsSid"=>"SM5[...]",
    #   "FromState"=>"CA",
    #   "SmsStatus"=>"received",
    #   "FromCity"=>"SAN DIEGO",
    #   "Body"=>"Test",
    #   "FromCountry"=>"US",
    #   "To"=>"+1[...]",
    #   "ToZip"=>"92064",
    #   "NumSegments"=>"1",
    #   "MessageSid"=>"SM5[...]",
    #   "AccountSid"=>"[...]",
    #   "From"=>"+1[...]",
    #   "ApiVersion"=>"2010-04-01"
    # }
    
    if body.nil?
      body = ""
    end
    if from.nil?
      from = "Unknown Number"
    end
    
    from = TextMessage.normalize(phone_number: from)
    
    transformed_body = body.downcase.gsub(/^please/, "").strip
    
    context_identity_id = nil
    last_text_message = nil
    mainline_processing = true
    
    # User can target a response by display name: "@UserX Response [...]"
    body.strip!
    if body.start_with?("@")
      i = body.index(" ")
      if !i.nil?
        target = body[1..i-1]
        last_text_message = LastTextMessage.where(
          "phone_number = :from AND from_display ILIKE :from_display",
          from: from,
          from_display: "#{target}%",
        ).order("updated_at DESC").limit(1).take
        
        if last_text_message.nil?
          mainline_processing = false
          twiml = Twilio::TwiML::MessagingResponse.new do |r|
            r.message(message: I18n.t("myplaceonline.twilio.display_not_found", name: target))
          end
        else
          body = body[i+1..-1]
        end
      end
    end
    
    if mainline_processing
      if last_text_message.nil?
        last_text_message = LastTextMessage.where(phone_number: from).order("updated_at DESC").limit(1).take
      end

      if !last_text_message.nil?
        context_identity_id = last_text_message.to_identity_id
      end
      
      if ["unsub", "remove", "stop"].any?{|x| transformed_body.start_with?(x)}
        
        TextMessageUnsubscription.create!(
          phone_number: from,
          identity_id: context_identity_id,
        )
        
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
          r.message(message: I18n.t("myplaceonline.twilio.unsubscribed"))
        end
        
      elsif ["sub", "resub"].any?{|x| transformed_body.start_with?(x)}
        
        TextMessageUnsubscription.where(
          phone_number: from,
          identity_id: context_identity_id,
        ).destroy_all
        
        twiml = Twilio::TwiML::MessagingResponse.new do |r|
          r.message(message: I18n.t("myplaceonline.twilio.resubscribed"))
        end
        
      elsif !context_identity_id.nil? && last_text_message.from_identity.has_mobile? && last_text_message.to_identity_id != last_text_message.from_identity_id
        
        # Pass it on to the most recent texter
        if !body.blank?
          
          if last_text_message.from_identity.send_sms(body: "#{last_text_message.to_identity.display_short}: #{body}")
            LastTextMessage.update_ltm(
              phone_number: last_text_message.from_identity.first_mobile_number.number,
              message_category: last_text_message.category,
              to_identity: last_text_message.from_identity,
              from_identity: last_text_message.to_identity,
            )
          end
        end
        
        twiml = Twilio::TwiML::MessagingResponse.new
        
      else
        Myp.warn("SMS Received from #{from}:\n\n#{body}", request: request)
        twiml = Twilio::TwiML::MessagingResponse.new
      end
    end
    
    render(body: twiml.to_s, content_type: "text/xml", layout: false)
  end
  
  def favicon_png
    handle_domain_image(
      child_property_name: :favicon_png_identity_file,
      default_file_name: "default_favicon.png",
      target_file_name: "favicon.png",
      content_type: "image/png",
    )
  end

  def favicon_ico
    handle_domain_image(
      child_property_name: :favicon_ico_identity_file,
      default_file_name: "default_favicon.ico",
      target_file_name: "favicon.ico",
      content_type: "image/vnd.microsoft.icon",
    )
  end
  
  def header_icon_png
    handle_domain_image(
      child_property_name: :default_header_icon_identity_file,
      default_file_name: "default_header_icon.png",
      target_file_name: "header_icon.png",
      content_type: "image/png",
    )
  end
  
  def handle_domain_image(child_property_name:, default_file_name:, target_file_name:, content_type:)
    request.session_options[:skip] = true
    domain = Myp.website_domain
    identity_file = domain.send(child_property_name)
    if !identity_file.nil?
      respond_identity_file(
        "inline",
        identity_file,
        target_file_name,
        content_type
      )
    else
      if Rails.env.production?
        file = Rails.root.join("public#{ActionController::Base.helpers.image_path(default_file_name)}")
      else
        file = Rails.root.join("app/assets/images/#{default_file_name}")
      end
      send_file(
        file,
        filename: target_file_name,
        disposition: "inline",
        type: content_type,
      )
    end
  end

  # For _generaterandom callback
  def category
    nil
  end
  
  # curl --header "Content-Type: application/json" --request POST --data '{"email": "email", "password": "password"}' http://localhost:3000/api/login_or_register
  def login_or_register
    status = 500
    result = false
    messages = []
    token = nil
    refresh_token = nil
    expires_in = nil
    
    email = params[:email]
    password = params[:password]
    invite_code = params[:invite_code]
    
    if email.blank?
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.errors.noemail")]
    elsif password.blank?
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.errors.nopassword")]
    else
      user = User.where(email: email).take
      
      # Register a new user
      if user.nil?
        if Myp.requires_invite_code && invite_code.blank?
          # Registration without an invite code
          result = false
          status = 401
          messages = [I18n.t("myplaceonline.general.requires_invite_code_short")]
        else
          user = User.new(email: email, password: password, password_confirmation: password, invite_code: invite_code)
          result = user.save
          if result
            authorization_result = get_oauth_token(user)
            if !authorization_result.is_a?(Doorkeeper::OAuth::ErrorResponse)
              token = authorization_result.token.plaintext_token
              refresh_token = authorization_result.token.plaintext_refresh_token
              expires_in = authorization_result.token.expires_in_seconds
              result = true
              status = 201
              messages = [I18n.t("myplaceonline.general.new_user_created") + " #{DateTime.now}"]
              
              Myp.send_support_email_safe(
                "New User #{user.email}",
                "New User #{user.email}",
                request: request,
              )
            else
              # Unclear why this would happen as we just created the user
              result = false
              status = 403
              messages = [authorization_result.description + " #{authorization_result.name.to_s}"]
            end
          else
            # Error creating the user for some reason (e.g. password too short)
            result = false
            status = 403
            messages = user.errors.full_messages
          end
        end
      else
        # Log in an existing user
        if user.valid_password?(password)
          if user.active_for_authentication?
            authorization_result = get_oauth_token(user)
            token = authorization_result.token.plaintext_token
            refresh_token = authorization_result.token.plaintext_refresh_token
            expires_in = authorization_result.token.expires_in_seconds
            result = true
            status = 200
            messages = [I18n.t("myplaceonline.general.login_successful") + " #{DateTime.now}"]
          else
            result = false
            status = 409
            messages = [I18n.t("myplaceonline.users.pending_confirmation")]
          end
        else
          result = false
          status = 404
          messages = [I18n.t("myplaceonline.errors.invalidpassword")]
        end
      end
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
        token: token,
        refresh_token: refresh_token,
        expires_in: expires_in,
      },
      status: status,
    )
  end
  
  def refresh_token
    status = 500
    result = false
    messages = []
    token = nil
    refresh_token = nil
    expires_in = nil
    
    incoming_token = params[:refresh_token]
    if !incoming_token.blank?
      refresh_result = get_oauth_refresh_token(incoming_token)
      if !refresh_result.is_a?(Doorkeeper::OAuth::ErrorResponse)
        result = true
        status = 200
        token = refresh_result.token.plaintext_token
        refresh_token = refresh_result.token.plaintext_refresh_token
        expires_in = refresh_result.token.expires_in_seconds
        messages = [I18n.t("myplaceonline.general.login_successful") + " #{DateTime.now}"]
      else
        result = false
        status = 403
        Rails.logger.debug{"refresh_token error: #{refresh_result.description} #{refresh_result.name.to_s}"}
        messages = [refresh_result.description + " #{refresh_result.name.to_s}"]
      end
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
        token: token,
        refresh_token: refresh_token,
        expires_in: expires_in,
      },
      status: status,
    )
  end
  
  def enter_invite_code
    authorize! :edit, current_user

    status = 403
    result = false
    messages = []
    
    invite_code = params[:invite_code]
    
    if Myp.requires_invite_code
      if InviteCode.valid_code?(invite_code)
        
        EnteredInviteCode.create!(
          user: current_user,
          website_domain: Myp.website_domain,
          code: invite_code,
          internal: true,
        )
        
        current_user.post_initialize

        result = true
        status = 200
      else
        result = false
        status = 403
        messages = [I18n.t("myplaceonline.users.invite_invalid_detailed")]
      end
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def add_identity
    authorize! :edit, current_user

    status = 500
    result = false
    messages = []
    
    name = params[:name]
    
    if !name.blank?
      
      new_identity = Identity.create!(
        user_id: current_user.id,
        name: name,
        website_domain_id: Myp.website_domain.id,
      )
      
      current_user.change_default_identity(new_identity)
      
      result = true
      status = 200
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.users.identity_name_blank")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def change_identity
    authorize! :edit, current_user

    status = 500
    result = false
    messages = []
    
    new_identity = params[:new_identity]
    
    if !new_identity.blank?
      new_identity_id = new_identity.to_i
      i = current_user.identities.index{|x| x.id == new_identity_id}
      if !i.nil?
        current_user.change_default_identity(current_user.identities[i])
        result = true
        status = 200
      else
        result = false
        status = 500
        messages = [I18n.t("myplaceonline.users.invalid_identity_id")]
      end
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.users.identity_id_blank")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def delete_identity
    authorize! :edit, current_user

    status = 500
    result = false
    messages = []
    
    identity = params[:identity]
    
    if !identity.blank?
      identity_id = identity.to_i
      i = current_user.identities.index{|x| x.id == identity_id}
      if !i.nil?
        ActiveRecord::Base.transaction do
          identity_to_delete = current_user.identities[i]
          new_main_identity = nil
          new_main_identity_id = nil
          if current_user.identities.size > 1
            j = current_user.identities.index{|x| x.id != identity_id}
            new_main_identity = current_user.identities[j]
            new_main_identity_id = new_main_identity.id
            current_user.change_default_identity(new_main_identity)
          end
          ExecutionContext.stack(allow_identity_delete: true) do
            # This identity may have created other identities
            Identity.where(identity_id: identity_to_delete.id).update_all(identity_id: new_main_identity_id)
            
            identity_to_delete.destroy!
          end
        end
        result = true
        status = 200
      else
        result = false
        status = 500
        messages = [I18n.t("myplaceonline.users.invalid_identity_id")]
      end
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.users.identity_id_blank")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def update_password
    authorize! :edit, current_user

    status = 500
    result = false
    messages = []
    
    old_password = params[:old_password]
    new_password = params[:new_password]
    
    if !old_password.blank?
      if !new_password.blank?
        if current_user.valid_password?(old_password)
          current_user.password = new_password
          current_user.password_confirmation = new_password
          current_user.save!
          result = true
          status = 200
        else
          result = false
          status = 500
          messages = [I18n.t("myplaceonline.api.invalid_old_password")]
        end
      else
        result = false
        status = 500
        messages = [I18n.t("myplaceonline.api.blank_new_password")]
      end
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.api.blank_old_password")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def update_email
    authorize! :edit, current_user

    status = 500
    result = false
    messages = []
    
    new_email = params[:email]
    password = params[:password]
    
    if !new_email.blank?
      if !password.blank?
        if current_user.valid_password?(password)
          current_user.email = new_email
          current_user.save!
          result = true
          status = 200
        else
          result = false
          status = 500
          messages = [I18n.t("myplaceonline.api.invalid_password")]
        end
      else
        result = false
        status = 500
        messages = [I18n.t("myplaceonline.api.blank_password")]
      end
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.api.blank_new_email")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def forgot_password
    status = 500
    result = false
    messages = []
    
    email = params[:email]
    
    if !email.blank?
      user = User.where(email: email).take
      if !user.nil?
        user.send_reset_password_instructions
        result = true
        status = 200
        messages = [I18n.t("myplaceonline.api.password_reset_sent")]
      else
        result = false
        status = 500
        messages = [I18n.t("myplaceonline.api.email_not_found")]
      end
    else
      result = false
      status = 500
      messages = [I18n.t("myplaceonline.api.blank_email")]
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def update_settings
    status = 500
    result = false
    messages = []
    
    settings = params[:settings]
    
    if !settings.blank?
      ActiveRecord::Base.transaction do
        settings.each do |k,v|
          Setting.set_value(category: nil, name: k, value: v)
        end
      end
      result = true
      status = 200
    else
      # Ok to not set anything
      result = true
      status = 200
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  def update_notification_settings
    status = 500
    result = false
    messages = []
    
    settings = params[:settings]
    
    if !settings.blank?
      NotificationPreference.update_settings(settings)
      result = true
      status = 200
    else
      # Ok to not set anything
      result = true
      status = 200
    end
    
    render(
      json: {
        status: status,
        result: result,
        messages: messages,
      },
      status: status,
    )
  end
  
  protected
    def json_error(error)
      render json: {
        success: false,
        error: error
      }
    end
    
    def create_newfile_result(newfile, params, newfilewrapper: nil, singular: false, singularNamePrefix: "")
      items = [
        {
          type: "raw",
          value: "<p>" + MyplaceonlineController.helpers.image_tag(file_thumbnail_name_path(newfile, newfile.urlname, t: newfile.updated_at.to_i), alt: newfile.display, title: newfile.display, class: "fit") + "</p>"
        },
        {
          type: "text",
          name: "identity_file_attributes.file_file_name",
          placeholder: t("myplaceonline.files.file_file_name"),
          value: newfile.file_file_name
        },
        {
          type: "textarea",
          name: "identity_file_attributes.notes",
          placeholder: t("myplaceonline.general.notes"),
          value: newfile.notes
        },
        {
          type: "hidden",
          name: "identity_file_attributes.id",
          value: newfile.id.to_s
        },
        {
          type: "hidden",
          name: "identity_file_attributes._updatetype",
          value: AllowExistingConcern::UPDATE_TYPE_COMBINE.to_s
        }
      ]
      
      if params[:position_field]
        items.push({
          type: "position",
          name: params[:position_field]
        })
      end
      
      if !newfilewrapper.nil?
        items.push({
          type: "hidden",
          name: "id",
          value: newfilewrapper.id.to_s
        })
      end

      {
        result: true,
        deletePlaceholder: I18n.t("myplaceonline.general.delete"),
        successNotification: I18n.t("myplaceonline.files.file_success", name: newfile.file_file_name),
        items: items,
        singular: singular,
        id: newfile.id,
        singularNamePrefix: singularNamePrefix,
      }
    end
    
    def get_oauth_token(user)
      app = Doorkeeper::Application.where(name: "Internal").take!
      client = Doorkeeper::OAuth::Client::Credentials.new(app.uid, app.secret)
      authenticated_app = Doorkeeper::OAuth::Client.authenticate(client)
      authorization_result = Doorkeeper::OAuth::PasswordAccessTokenRequest.new(Doorkeeper.configuration, authenticated_app, user).authorize()
      return authorization_result
    end
    
    def get_oauth_refresh_token(refreshToken)
      accessToken = Doorkeeper::AccessToken.by_refresh_token(refreshToken)
      Rails.logger.debug{"get_oauth_refresh_token accessToken: #{accessToken.inspect}"}
      app = Doorkeeper::Application.where(name: "Internal").take!
      client = Doorkeeper::OAuth::Client::Credentials.new(app.uid, app.secret)
      authorization_result = Doorkeeper::OAuth::RefreshTokenRequest.new(Doorkeeper.configuration, accessToken, client).authorize()
      return authorization_result
    end
end
