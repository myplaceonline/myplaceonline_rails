class CreditCardsController < MyplaceonlineController
  def model
    CreditCard
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(credit_cards.name) ASC"]
    end

    def obj_params
      params.require(:credit_card).permit(
        :name,
        :number,
        :expires,
        :security_code,
        :pin,
        :notes,
        :encrypt,
        :is_defunct,
        select_or_create_permit(:credit_card, :password_attributes, PasswordsController.param_names),
        select_or_create_permit(:credit_card, :address_attributes, LocationsController.param_names)
      )
    end
    
    def create_presave
      if !@obj.password.nil?
        @obj.password.identity = current_user.primary_identity
      end
      if !@obj.address.nil?
        @obj.address.identity = current_user.primary_identity
      end
    end

    def sensitive
      true
    end

    def create_presave
      @obj.number_finalize
      @obj.security_code_finalize
      @obj.pin_finalize
      @obj.expires_finalize
      update_defunct
    end

    def update_presave
      @obj.number_finalize
      @obj.security_code_finalize
      @obj.pin_finalize
      @obj.expires_finalize
      update_defunct
    end
    
    def update_defunct
      if @obj.is_defunct == "1"
        @obj.defunct = Time.now
      else
        @obj.defunct = nil
      end
    end

    def before_edit
      @obj.encrypt = @obj.number_encrypted?
      @obj.is_defunct = !@obj.defunct.nil?
    end
end
