class ApiController < ApplicationController
  include Rails.application.routes.url_helpers

  skip_authorization_check
  
  skip_before_action :verify_authenticity_token, only: [:debug]
  
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
    response = Myp.full_text_search(
      current_user,
      params[:q],
      category: params[:category],
      parent_category: params[:parent_category],
      display_category_prefix: display_category_prefix,
      display_category_icon: display_category_icon
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
          if !model.column_names.index(column_name).nil?
            render json: model.find_by_sql(%{
              SELECT DISTINCT #{column_name}
              FROM #{model.table_name}
              WHERE identity_id = #{User.current_user.primary_identity.id}
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

          objclass_index = 1
          
          # This upload may come from the root element or from a child form submission
          paramnode = nil
          while paramnode.nil?
            if spliturl[objclass_index].nil?
              objclass_index -= 2
              break
            end
            objclass = spliturl[objclass_index].singularize
            paramnode = params[objclass]
            
            Rails.logger.debug{"checking objclass: #{objclass}, paramnode: #{paramnode}"}
            
            if paramnode.nil?
              objclass_index += 2
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

          Rails.logger.debug{"initial node: #{paramnode}"}
          
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
            
            # Regex checking for only digits
            if !!(key =~ /\A[-+]?[0-9]+\z/)
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

                    Rails.logger.debug{"saving: #{prevnode.inspect}"}

                    prevnode.save!

                    newfile = newfilewrapper.identity_file
                  else
                    newfile = IdentityFile.create(val["identity_file_attributes"])
                  end

                  Rails.logger.debug{"newfile: #{newfile.inspect}"}
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
                  Rails.logger.debug{"nested indexed node: #{obj.inspect}"}
                end
              end
            else
              prevnode = obj
              prevkey = key
              prevkey_full = pair[0]
              
              if !obj.nil?
                obj = obj.send(key)
                Rails.logger.debug{"nested node: #{obj.inspect}"}
              end
            end
          end
          if !result[:result]
            # Just a simple add of a file
            if !params[:identity_file].nil?
              newfile = IdentityFile.create(params.require(:identity_file).permit(FilesController.param_names))
              Rails.logger.debug{"newfile final: #{newfile.inspect}"}
              result = create_newfile_result(newfile, params, singular: true)
            end
          end
        end
      end
    end
    
    render json: result
  end
  
  def create_newfile_result(newfile, params, newfilewrapper: nil, singular: false)
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
      id: newfile.id
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
      Myp.warn("website_title error with #{link}", e)
      result[:error] = e.to_s
    end
    render json: result
  end

  protected
    def json_error(error)
      render json: {
        success: false,
        error: error
      }
    end
end
