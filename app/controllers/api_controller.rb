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
    respond_to do |format|
      format.json { render json: Myp.full_text_search(current_user, params[:q]) }
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
    possibilities = Myp::POSSIBILITIES_ALPHANUMERIC_PLUS_SPECIAL
    result = (0...length).map { possibilities[SecureRandom.random_number(possibilities.length)] }.join
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
      begin
        UserMailer.send_support_email(current_user.email, "Quick Feedback", request.raw_post).deliver_now
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
    from = Myplaceonline::DEFAULT_SUPPORT_EMAIL
    if !current_user.nil?
      from = current_user.email
    end
    UserMailer.send_support_email(from, "Javascript Error", request.raw_post).deliver_now
    
    # So that a script kiddie doesn't DoS our email server
    sleep(1.0)
    
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
      :result => result
    }
    urlpath = params[:urlpath]
    urlsearch = params[:urlpath]
    urlhash = params[:urlhash]
    if !urlpath.blank?
      spliturl = urlpath.split('/')
      if spliturl.length >= 3
        objclass = spliturl[1].singularize
        objid = spliturl[2]
        obj = Myp.find_existing_object(objclass, objid, false)
        authorize! :edit, obj
        
        # Alrighty, we've got the object and the user is authorized, so
        # now we can start the real work
        
        # We'll only have the file object, so just follow the path of params
        # for the object down to right above the file leaf node
        paramnode = params[objclass]
        prevnode = obj
        prevkey = nil
        prevkey_full = nil

        Rails.logger.debug{"initial node: #{paramnode}, obj: #{obj.inspect}"}
        
        keepgoing = true
        while keepgoing do
          pair = paramnode.to_a[0]
          key = pair[0]
          val = paramnode = pair[1]
          
          Rails.logger.debug{"key: #{key}, val: #{val}"}
          
          if key.end_with?("_attributes")
            key = key[0..key.index("_attributes")-1]
          end
          if !!(key =~ /\A[-+]?[0-9]+\z/)
            ikey = key.to_i
            
            # If the next child is identity_file_attributes, then we know
            # we're done
            if val.has_key?("identity_file_attributes")
              
              if prevkey_full.end_with?("_attributes")
                
                Rails.logger.debug{"prevkey: #{prevkey}"}

                prevkeyclass = Object.const_get(prevkey.singularize.to_s.camelize)

                newfilewrapper = prevkeyclass.new(val)
                
                prevnode.send(prevkey) << newfilewrapper

                Rails.logger.debug{"saving: #{prevnode.inspect}"}

                prevnode.save!

                newfile = newfilewrapper.identity_file
                
              else
                Rails.logger.debug{"prevkey: #{prevkey}"}

                newfile = IdentityFile.new(val["identity_file_attributes"])

                Rails.logger.debug{"newfile: #{newfile.inspect}"}
                
                #prevnode.send(prevkey) << newfile

                Rails.logger.debug{"prevkey: #{prevkey}, saving: #{prevnode.inspect}"}

                #prevnode.save!
                
                raise "todo"
              end
              
              newfile.ensure_thumbnail
              
              if newfile.has_thumbnail?
                html = "thubmnail"
              else
                html = "no thumbnail"
              end
              
              items = [
                {
                  type: "raw",
                  value: "<p>" + MyplaceonlineController.helpers.image_tag(file_thumbnail_path(newfile, :h => newfile.thumbnail_hash)) + "</p>"
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
                }
              ]
              
              if params[:position_field]
                items.push({
                  type: "position",
                  name: params[:position_field]
                })
              end

              result = {
                result: true,
                deletePlaceholder: I18n.t("myplaceonline.general.delete"),
                successNotification: I18n.t("myplaceonline.files.file_success", name: newfile.file_file_name),
                items: items
              }
              
              keepgoing = false

              Rails.logger.debug{"breaking loop"}
            else
              # Otherwise just index in
              prevnode = obj
              prevkey = key
              prevkey_full = pair[0]
              obj = obj[ikey]
              
              Rails.logger.debug{"nested indexed node: #{obj.inspect}"}
              
            end
          else
            prevnode = obj
            prevkey = key
            prevkey_full = pair[0]
            obj = obj.send(key)
            Rails.logger.debug{"nested node: #{obj.inspect}"}
          end
        end
      end
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
