class ConnectionsController < MyplaceonlineController

  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:accept]

  def self.param_names
    [
      user_attributes: [
        :id
      ]
    ]
  end
  
  def accept
    Myp.ensure_encryption_key(session)
    @obj = model.where(id: params[:id].to_i, connection_request_token: params[:token]).first
    if !@obj.nil?
      if @obj.user.id == User.current_user.id
        @obj.connection_status = Connection::STATUS_CONNECTED
        @obj.save!
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
end
