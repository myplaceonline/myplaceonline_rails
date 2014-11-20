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
    if @password.save
      redirect_to @password
    else
      render :new
    end
  end
    
  def show
    @password = findPassword
  end
  
  def edit
    @password = findPassword
  end
  
  def update
    @password = findPassword

    if @password.update(password_params)
      redirect_to @password
    else
      render :edit
    end
  end
  
  def destroy
    @article = findPassword
    @article.destroy

    redirect_to passwords_path
  end
  
  private
    def password_params
      # Without the require call, render new in create doesn't persist values
      params.require(:password).permit(:name, :user, :password, :is_encrypted_password)
    end

    def findPassword
      Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
    end
end
