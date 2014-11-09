class PasswordsController < MyplaceonlineController
  def index
    @passwords = Password.where(identity_id: current_user.primary_identity.id)
  end
  
  def new
    @password = Password.new
  end
  
  def create
    @password = Password.new(password_params)
    @password.identity_id = current_user.primary_identity.id
    encryption_holder = Myp.encrypt(session, @password.password)
    puts encryption_holder.inspect
    #salt = SecureRandom.random_bytes(64)
    #key = ActiveSupport::KeyGenerator.new('password').generate_key(salt)
    # TODO: ActiveSupport::MessageEncryptor
    if @password.save
      redirect_to @password
    else
      render "new"
    end
  end
    
  def show
    @password = Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
  end
  
  def edit
    @password = Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
  end
  
  def update
    @password = Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)

    if @password.update(password_params)
      redirect_to @password
    else
      render "edit"
    end
  end
  
  def destroy
    @article = Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
    @article.destroy

    redirect_to passwords_path
  end

  private
  def password_params
    params.require(:password).permit(:name, :user, :password)
  end
end
