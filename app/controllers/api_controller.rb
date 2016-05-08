class ApiController < ApplicationController

  skip_authorization_check
  
  skip_before_action :verify_authenticity_token, only: [:debug]
  
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categories_for_current_user(current_user, nil, true)}
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
  
  protected
    def json_error(error)
      render json: {
        success: false,
        error: error
      }
    end
end
