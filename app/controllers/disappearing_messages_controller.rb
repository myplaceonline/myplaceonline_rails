class DisappearingMessagesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:read]

  def read
    @name = ""
    @message = ""
    id = params[:id]
    params[:noheader] = true
    m = DisappearingMessage.where(uuididentifier: id).take
    if !m.nil?
      @name = m.name
      @message = m.notes
      MyplaceonlineExecutionContext.do_full_context(m.identity.user, m.identity) do
        m.destroy!
      end
    else
      @message = "ERROR: Message not found"
    end
  end

  def precreate
    @obj.uuididentifier = SecureRandom.uuid
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def default_sort_columns
      ["disappearing_messages.updated_at"]
    end

    def obj_params
      params.require(:disappearing_message).permit(
        :name,
        :notes,
      )
    end
end
