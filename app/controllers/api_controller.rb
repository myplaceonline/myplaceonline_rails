class ApiController < ApplicationController
  include Rails.application.routes.url_helpers

  skip_authorization_check

  # Only applies for POST methods (http://api.rubyonrails.org/classes/ActionController/RequestForgeryProtection/ClassMethods.html#method-i-protect_from_forgery)
  skip_before_action :verify_authenticity_token, only: [:debug, :twilio_sms]
  
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
      filters: filters
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
    
    render json: {
      :randomString => result
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
    if !current_user.nil? && !current_user.primary_identity.nil?
      user_input = params[:user_input]
      begin
        content = user_input + "\n\n" + params.except(:user_input).inspect
        UserMailer.send_support_email(
          current_user.email,
          "Quick Feedback",
          content,
          content
        ).deliver_now
        render json: {
          :result => true
        }
      rescue Exception => e
        render json: {
          :result => true,
          :error => e.to_s
        }
      end
    else
      render json: {
        :result => false
      }
    end
  end
  
  def debug
    
    body_markdown = "Message: " + params[:message].to_s + "\n\n" + "Stack: " + params[:stack].to_s
    
    Myp.send_support_email_safe("Browser Error", Myp.markdown_to_html(body_markdown.gsub("\n", "<br />\n")).html_safe, body_markdown)
    
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
    urlsearch = params[:urlpath]
    urlhash = params[:urlhash]
    
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
        Myp.warn("website_title error with URL: '#{link}'", e)
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
        Myp.warn("SMS Received from #{from}:\n\n#{body}")
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

  protected
    def json_error(error)
      render json: {
        success: false,
        error: error
      }
    end
end
