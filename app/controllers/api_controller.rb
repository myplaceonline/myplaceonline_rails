class ApiController < ApplicationController

  skip_authorization_check
  
  def index
  end
  
  def categories
    respond_to do |format|
      format.json { render json: Myp.categories_for_current_user(current_user, nil, true)}
    end
  end
  
  def randomString
    length = Myp.default_password_length
    if !params[:length].nil?
      length = params[:length].to_i
      if length <= 0 || length > 512
        length = Myp.default_password_length
      end
    end
    possibilities = Myp.password_possibilities_alphanumeric_plus_special
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
  
  def updatenotepad
    if !current_user.nil? && !current_user.primary_identity.nil?
      new_notepad = request.raw_post
      current_user.primary_identity.notepad = new_notepad
      current_user.primary_identity.save!
      render json: {
        :result => true
      }
    else
      render json: {
        :result => false
      }
    end
  end
  
  def quickfeedback
    if !current_user.nil? && !current_user.primary_identity.nil?
      begin
        UserMailer.send_support_email(current_user.email, "Quick Feedback", request.raw_post).deliver
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
  
  protected
    def json_error(error)
      render json: {
        success: false,
        error: error
      }
    end
end
