class PasswordsController < MyplaceonlineController
  def index
    @passwords = Password.where(identity_id: current_user.primary_identity.id)
  end
  
  def new
    @password = Password.new
  end
  
  def create
    @password = Password.new(password_params)
    ActiveRecord::Base.transaction do
      @password.identity_id = current_user.primary_identity.id
      
      # Only bother checking encryption if the password is valid
      # (i.e. the save will fail)
      if @password.valid?
        if !encryptIfNeeded(@password)
          return render :new
        end
      end
      
      if @password.save
        redirect_to @password
      else
        render :new
      end
    end
  end
    
  def show
    @password = findPassword
  end
  
  def edit
    @password = findPassword
    @password.password = @password.getPassword(session)
  end
  
  def update
    @password = findPassword

    ActiveRecord::Base.transaction do
      
      @password.attributes=(password_params)
      
      # Only bother checking encryption if the password is valid
      # (i.e. the save will fail)
      if @password.valid?
        # if there's an encrypted value and the user unchecked encrypt
        # then we can delete the encrypted value
        if !@password.is_encrypted_password && !@password.encrypted_password.nil?
          @password.encrypted_password.destroy
        end
        if !encryptIfNeeded(@password)
          return render :edit
        end
      end

      if @password.save
        redirect_to @password
      else
        render :edit
      end
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
      return Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
    end
    
    def encryptIfNeeded(password)
      if password.is_encrypted_password
        encrypted_value = Myplaceonline.encryptFromSession(session, password.password)
        if encrypted_value.save
          password.encrypted_password = encrypted_value
          password.password = nil
        else
          flash.now[:error] = t("myplaceonline.errors.couldnotencrypt")
          return false
        end
      end
      return true
    end
end
