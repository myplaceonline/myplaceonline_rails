class ConnectionsController < MyplaceonlineController

  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:accept, :allconnections]

  def self.param_names
    [
      user_attributes: [
        :id
      ]
    ]
  end
  
  def allconnections
    @objs = Connection.where(
      identity_id: User.current_user.primary_identity_id,
      connection_status: Connection::STATUS_CONNECTED
    ).map{|x| x.user}
    if !params[:q].blank?
      search = params[:q].strip.downcase
      @objs.delete_if{|x| x.display.index(search).nil? }
    end
  end
  
  def accept
    check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    
    @obj = Connection.where(
      id: params[:id].to_i,
      connection_request_token: params[:token]
    ).first
    
    if !@obj.nil?
      if @obj.user.id == User.current_user.id
        
        ActiveRecord::Base.transaction do
          # Update the connection object of the requesting user
          # to set the status to connected
          MyplaceonlineExecutionContext.do_permission_target(@obj.identity) do
            @obj.connection_status = Connection::STATUS_CONNECTED
            @obj.contact = Connection.create_contact(User.current_user.email)
            @obj.save!
          end
          
          # Create our own connection
          my_connection = Connection.new
          my_connection.connection_status = Connection::STATUS_CONNECTED
          my_connection.user = @obj.identity.user
          my_connection.contact = Connection.create_contact(@obj.identity.user.email)
          my_connection.save!
        end
        
        body_markdown = I18n.t(
          "myplaceonline.connections.connection_accepted_body",
          name: User.current_user.display,
          link: Rails.application.routes.url_helpers.send("connection_url", @obj.id, Rails.configuration.default_url_options)
        )
        
        Myp.send_email(
          @obj.identity.user.email,
          I18n.t("myplaceonline.connections.connection_accepted", name: User.current_user.display),
          Myp.markdown_to_html(body_markdown).html_safe,
          nil,
          nil,
          body_markdown,
          User.current_user.email
        )
        
        redirect_to connections_path,
          :flash => { :notice => I18n.t("myplaceonline.connections.connection_accepted", name: @obj.identity.display) }
      else
        redirect_to connections_path,
          :flash => { :notice => I18n.t("myplaceonline.connections.connection_accept_invalid") }
      end
    else
      redirect_to connections_path,
        :flash => { :notice => I18n.t("myplaceonline.connections.connection_accept_invalid") }
    end
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["connections.updated_at DESC"]
    end

    def obj_params
      params.require(:connection).permit(ConnectionsController.param_names)
    end
    
    def after_create
      redirect_to obj_path, :flash => { :notice => I18n.t("myplaceonline.connections.connection_pending", name: @obj.user.display) }
    end
end
