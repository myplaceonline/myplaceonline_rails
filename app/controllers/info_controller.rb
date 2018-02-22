require "awesome_print"

class InfoController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  skip_before_action :verify_authenticity_token, only: [:upload]
  
  def hello_world
  end
  
  def index; end
  def credits; end
  def diagnostics; end

  def faq; end
  
  def serverinfo; end
  def jqm; end
    
  def clientinfo
    @browser = ap(MyplaceonlineExecutionContext.browser, html: true)
  end
  
  def checkboxes; end

  def sleep_time
    if !current_user.nil? && current_user.admin?
      duration = params[:duration]
      if duration.blank?
        duration = 1
      else
        duration = duration.to_f
      end
      sleep(duration)
    end
    redirect_to info_diagnostics_path
  end

  def raise_server_exception
    if !current_user.nil? && current_user.admin?
      raise "Fake Server Exception"
    end
    redirect_to info_diagnostics_path
  end
  
  def raise_server_warning
    if !current_user.nil? && current_user.admin?
      begin
        raise "Test exception"
      rescue Exception => e
        Myp.warn("Test server warning", e, request: request)
      end
    end
    redirect_to info_diagnostics_path
  end
  
  def contact
    @obj = SiteContact.new
    if !params[:subject].blank?
      @obj.subject = params[:subject]
    end
    if request.post?
      @obj = SiteContact.new(
        params.require(:site_contact).permit(
          :name,
          :email,
          :subject,
          :body
        )
      )
      if @obj.save
        email_prefix = "#{@obj.name} (#{@obj.email}) submitted the contact form:\n\n"
        Myp.send_support_email_safe(
          @obj.subject,
          "<p>" + email_prefix + "</p>" + Myp.markdown_to_html(@obj.body),
          email_prefix + @obj.body,
          email: @obj.email,
          request: request,
          html_comment_details: true,
        )
        redirect_to "/",
          :flash => { :notice =>
                      I18n.t("myplaceonline.contact.sent")
                    }
      end
    end
  end
  
  def invite
    check_password
    @obj = Invite.new
    @obj.email = params[:email]
    if request.post?
      @obj = Invite.new(
        params.require(:invite).permit(
          :email,
          :invite_body
        )
      )
      @obj.user = User.current_user
      if Invite.find_by_sql(%{
        SELECT invites.*
        FROM invites
        WHERE lower(invites.email) = #{ActiveRecord::Base.connection.quote(@obj.email.downcase)} AND user_id = #{@obj.user.id}
      }).count == 0
        if @obj.save
          body_markdown = I18n.t(
            "myplaceonline.info.invite_body_markdown",
            name: User.current_user.display,
            link: LinkCreator.url("root"),
            additional_body: @obj.invite_body,
            host: Myp.website_domain.display,
          )
          
          Myp.send_email(
            @obj.email,
            I18n.t("myplaceonline.info.invite_subject", host: Myp.website_domain.display, name: User.current_user.display),
            Myp.markdown_to_html(body_markdown).html_safe,
            nil,
            nil,
            body_markdown,
            User.current_user.email
          )

          redirect_to "/",
            :flash => { :notice =>
                        I18n.t("myplaceonline.info.invite_sent")
                      }
        end
      else
        flash[:error] = t("myplaceonline.info.invite_duplicate")
      end
    end
  end
  
  def upload
    if request.post?
      file = params[:file]
      if !file.nil?
        # If it's an UploadedFile object, then this was just a normal form submission; otherwise, it's been processed
        # by nginx-upload-module
        if file.is_a?(ActionDispatch::Http::UploadedFile)
          # http://api.rubyonrails.org/classes/ActionDispatch/Http/UploadedFile.html
          result = "Successfully uploaded. Name: #{file.original_filename}, Size: #{file.size}, Content type: #{file.content_type}"
        else
          # {
          #   "file" => {
          #     "original_filename"=>"helloworld.txt",
          #     "content_type"=>"text/plain",
          #     "path"=>"/var/lib/remotenfs//uploads/0063322223",
          #     "md5"=>"e59ff97941044f85df5297e1c302d260",
          #     "size"=>"12"
          #   },
          #   "submit" => "blah"
          # }
          result = "Successfully uploaded. Name: #{file[:original_filename]}, Size: #{file[:size]}, Content type: #{file[:content_type]}"
        end
      else
        result = "No file selected"
      end
      flash[:notice] = result
      Rails.logger.info{"InfoController.upload #{result}"}
    end
  end
  
  def terms
    @content = Myp.parse_yaml_to_html("myplaceonline.terms").gsub("${HOST}", Myp.website_domain.display)
  end
  
  def privacy
    @content = Myp.parse_yaml_to_html("myplaceonline.privacy_policy").gsub("${HOST}", Myp.website_domain.display)
  end

  def clear_cookies
    cookie_names = MyplaceonlineExecutionContext.persistent_user_store.items.map{|x| x[0]}
    cookie_names.each do |cookie_name|
      MyplaceonlineExecutionContext.persistent_user_store.delete(cookie_name)
    end
    redirect_to(root_path, flash: { notice: I18n.t("myplaceonline.info.cookies_clear", num: cookie_names.size) })
  end
end
