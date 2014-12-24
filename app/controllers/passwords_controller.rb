require 'roo'

class PasswordsController < ApplicationController
  skip_authorization_check :only => [:index, :new, :create, :import, :importodf]
  
  def index
    Myp.ensure_encryption_key(session)
    Myp.visit(current_user, :passwords)
    @count = Password.where(
      identity_id: current_user.primary_identity.id
    ).count
    @offset = params[:offset].nil? ? 0 : params[:offset].to_i
    if @offset < 0
      @offset = 0
    end
    @perpage = params[:perpage].nil? ? 10 : params[:perpage].to_i
    if @perpage <= 0
      @perpage = @count
    end
    @passwords = Password.where(
      identity_id: current_user.primary_identity.id
    ).offset(@offset).limit(@perpage)
     .order("lower(passwords.name) ASC", "lower(passwords.user) ASC")
  end
  
  def new
    @url = new_password_path
    if request.post?
      create
    else
      @password = Password.new
      @password.is_encrypted_password = current_user.encrypt_by_default
    end
  end
  
  def create
    @password = Password.new(password_params)
    ActiveRecord::Base.transaction do
      @password.identity_id = current_user.primary_identity.id
      
      # Only bother checking encryption if the password is valid
      # (i.e. the save will fail)
      if @password.valid?
        if !encrypt_if_needed(@password)
          return render :new
        end
      end
      
      if @password.save
        Myp.add_point(current_user, :passwords)
        redirect_to @password
      else
        render :new
      end
    end
  end
  
  def show
    Myp.ensure_encryption_key(session)
    @password = find_password
    authorize! :manage, @password
    @displaypassword = @password.getPassword(session)
  end
  
  def edit
    Myp.ensure_encryption_key(session)
    @password = find_password
    authorize! :manage, @password
    @password.password = @password.getPassword(session)
    @url = @password
  end
  
  def update
    Myp.ensure_encryption_key(session)
    @password = find_password
    authorize! :manage, @password

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
        if !encrypt_if_needed(@password)
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
    Myp.ensure_encryption_key(session)
    @password = find_password
    authorize! :manage, @password
    ActiveRecord::Base.transaction do
      @password.destroy
      Myp.subtract_point(current_user, :passwords)
    end

    redirect_to passwords_path
  end
  
  def import
  end
  
  def importodf
    Myp.ensure_encryption_key(session)
    @password = ""
    if request.post?
      if params.has_key?(:file)
        begin
          file = params[:file]
          @password = params[:password]
          
          ActiveRecord::Base.transaction do
            identity_file = IdentityFile.new()
            identity_file.identity = current_user.primary_identity
            identity_file.file = file
            if !@password.to_s.empty?
              identity_file.encrypted_password = Myp.encrypt_from_session(current_user, session, @password)
            end
            identity_file.save!
            
            # Try to read the file
            s = Roo::OpenOffice.new(identity_file.file.to_file.path, :password => @password, :file_warning => :ignore)
            
            @url = passwords_import_odf1_path(identity_file.id)
          end
        rescue Myp::DecryptionKeyUnavailableError
          @url = Myp.reentry_url(request)
        rescue StandardError => error
          Myp.log_error(logger, error)
          @error = error.to_s
        end
      else
        @error = t("myplaceonline.import.nofile")
      end
    end
  end
  
  def importodf1
    Myp.ensure_encryption_key(session)
    ifile = IdentityFile.find_by(identity: current_user.primary_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.getPassword(session), :file_warning => :ignore)
      @sheets = s.sheets
    end
  end
  
  def importodf2
    Myp.ensure_encryption_key(session)
    ifile = IdentityFile.find_by(identity: current_user.primary_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      @encrypt = current_user.encrypt_by_default
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.getPassword(session), :file_warning => :ignore)
      @sheet = params[:sheet]
      s.default_sheet = s.sheets[s.sheets.index(@sheet)]
      @columns = Array.new
      for i in 1..s.last_column
        @columns.push(s.cell(s.first_row, i))
      end
    end
  end
  
  def importodf3
    Myp.ensure_encryption_key(session)
    ifile = IdentityFile.find_by(identity: current_user.primary_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.getPassword(session), :file_warning => :ignore)
      @sheet = params[:sheet]
      s.default_sheet = s.sheets[s.sheets.index(@sheet)]
      @columns = Array.new
      for i in 1..s.last_column
        @columns.push(s.cell(s.first_row, i))
      end
      
      last_row = params[:maximum_row]
      if last_row.to_s.empty?
        last_row = s.last_row.to_s
      end
      last_row = last_row.to_i
      imported_count = 0
      @encrypt = "1".eql? params[:is_encrypted_password]
      
      inputs = [
                :password_column, :service_name_column, :user_name_column,
                :notes_column, :notes_column_2, :account_number_column,
                :url_column,
                :secret_question_1_column, :secret_answer_1_column,
                :secret_question_2_column, :secret_answer_2_column,
                :secret_question_3_column, :secret_answer_3_column,
                :secret_question_4_column, :secret_answer_4_column,
                :secret_question_5_column, :secret_answer_5_column
               ]
      
      colindices = Hash.new
      inputs.each { |col| colindices[col] = get_plus1(@columns, params[col]) }
      
      if !colindices[:password_column].nil?
        if !colindices[:service_name_column].nil?
          ActiveRecord::Base.transaction do
            points = 0
            for i in (s.first_row + 1)..last_row
              password = Password.new
              password.identity_id = current_user.primary_identity.id

              password.password = s.cell(i, colindices[:password_column]).to_s
              if @encrypt
                password.is_encrypted_password = true
                password.encrypted_password = Myp.encrypt_from_session(current_user, session, password.password)
                password.password = nil
              end

              password.name = s.cell(i, colindices[:service_name_column]).to_s
              if !colindices[:user_name_column].nil?
                password.user = s.cell(i, colindices[:user_name_column]).to_s
              end
              if !colindices[:notes_column].nil?
                if password.notes.to_s.empty?
                  password.notes = ""
                else
                  password.notes += "\n"
                end
                password.notes += s.cell(i, colindices[:notes_column]).to_s
              end
              if !colindices[:notes_column_2].nil?
                if password.notes.to_s.empty?
                  password.notes = ""
                else
                  password.notes += "\n"
                end
                password.notes += s.cell(i, colindices[:notes_column_2]).to_s
              end
              if !colindices[:account_number_column].nil?
                password.account_number = s.cell(i, colindices[:account_number_column]).to_s
              end
              if !colindices[:url_column].nil?
                password.url = s.cell(i, colindices[:url_column]).to_s
              end
              
              password.save!

              add_secret(s, i, password, @encrypt, colindices, :secret_question_1_column, :secret_answer_1_column)
              add_secret(s, i, password, @encrypt, colindices, :secret_question_2_column, :secret_answer_2_column)
              add_secret(s, i, password, @encrypt, colindices, :secret_question_3_column, :secret_answer_3_column)
              add_secret(s, i, password, @encrypt, colindices, :secret_question_4_column, :secret_answer_4_column)
              add_secret(s, i, password, @encrypt, colindices, :secret_question_5_column, :secret_answer_5_column)
              
              points = points + 1
            end
            Myp.modify_points(current_user, :passwords, points)
          end
          redirect_to passwords_path, :flash => { :notice => I18n.t("myplaceonline.passwords.imported_count", :count => imported_count) }
        else
          flash[:error] = t("myplaceonline.passwords.service_name_col_required")
          render :importodf2
        end
      else
        flash[:error] = t("myplaceonline.passwords.password_col_required")
        render :importodf2
      end
    end
  end
  
  private
    def password_params
      # Without the require call, render new in create doesn't persist values
      params.require(:password).permit(
        :name,
        :user,
        :password,
        :is_encrypted_password,
        :url,
        :account_number,
        :notes,
        password_secrets_attributes: [:id, :question, :answer]
      )
    end

    def find_password
      Password.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
    end
    
    def get_plus1(array, name)
      result = array.index(name)
      if !result.nil?
        result += 1
      end
      result
    end
    
    def add_secret(s, i, password, encrypt, colindices, question_col, answer_col)
      if !colindices[question_col].nil? && !colindices[answer_col].nil?
        secret = PasswordSecret.new
        secret.password = password
        secret.question = s.cell(i, colindices[question_col]).to_s
        secret.answer = s.cell(i, colindices[answer_col]).to_s
        if !secret.question.empty?
          if encrypt
            secret.is_encrypted_answer = true
            secret.encrypted_answer = Myp.encrypt_from_session(current_user, session, secret.answer)
            secret.answer = nil
          end
          secret.save!
        end
      end
    end
    
    def encrypt_if_needed(password)
      if password.is_encrypted_password
        encrypted_value = Myp.encrypt_from_session(current_user, session, password.password)
        if encrypted_value.save
          password.encrypted_password = encrypted_value
          password.password = nil
        else
          flash.now[:error] = t("myplaceonline.errors.couldnotencrypt")
          return false
        end
      end
      true
    end
end
