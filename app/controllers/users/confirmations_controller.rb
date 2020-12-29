class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_authorization_check

  skip_before_action :verify_authenticity_token, only: [
    :create
  ]
  
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      Rails.logger.debug{"ConfirmationsController.after_confirmation_path_for domain: #{Myp.website_domain}"}
      
      domain = Myp.website_domain
      if !domain.nil? && !domain.confirm_redirect.blank?
        domain.confirm_redirect
      else
        super(resource_name, resource)
      end
    end
end
