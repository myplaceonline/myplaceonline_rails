class PasswordsController < MyplaceonlineController
  def index
    @resources = Password.where(identity_id: current_user.primary_identity.id)
  end
  
  def new
    @resource = Password.new
  end
  
  def create
    @resource = Password.new(resource_params)
    @resource.identity_id = current_user.primary_identity.id
    # TODO: ActiveSupport::MessageEncryptor
    if @resource.save
      redirect_to @resource
    else
      render 'new'
    end
  end
    
  def show
    @resource = Password.where(id: params[:id], identity_id: current_user.primary_identity.id)
  end

  private
  def resource_params
    params.require(:password).permit(:name, :user, :password)
  end
end
