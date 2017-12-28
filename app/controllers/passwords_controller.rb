require 'roo'

class PasswordsController < MyplaceonlineController
  
  SHARE_EXPIRE = 2.days
  
  MAX_PASSWORD_LENGTH = :max_password_length
  USE_LOWERCASE = :use_lowercase
  USE_UPPERCASE = :use_uppercase
  USE_NUMBERS = :use_numbers
  USE_SPECIAL = :use_special
  USE_SPECIAL_ADDITIONAL = :use_special_additional

  skip_authorization_check :only => [:index, :new, :create, :import, :importodf]
  
  def import
  end
  
  def importodf
    check_password

    @password = ""
    if request.post?
      if params.has_key?(:file)
        begin
          file = params[:file]
          @password = params[:password]
          
          ApplicationRecord.transaction do
            identity_file = IdentityFile.new()
            identity_file.identity = current_user.current_identity
            identity_file.file = file
            if !@password.to_s.empty?
              identity_file.encrypted_password = Myp.encrypt_with_user_password!(current_user, @password)
            end
            identity_file.save!
            
            Myp.add_point(current_user, "files", session)
            
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
    check_password
    ifile = IdentityFile.find_by(identity: current_user.current_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.get_password(session), :file_warning => :ignore)
      @sheets = s.sheets
    end
  end
  
  def importodf2
    check_password
    ifile = IdentityFile.find_by(identity: current_user.current_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      @encrypt = current_user.encrypt_by_default
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.get_password(session), :file_warning => :ignore)
      @sheet = params[:sheet]
      s.default_sheet = s.sheets[s.sheets.index(@sheet)]
      @columns = Array.new
      for i in 1..s.last_column
        @columns.push(s.cell(s.first_row, i))
      end
    end
  end
  
  def importodf3
    check_password
    ifile = IdentityFile.find_by(identity: current_user.current_identity, id: params[:id])
    if !ifile.nil?
      authorize! :manage, ifile
      s = Roo::OpenOffice.new(ifile.file.to_file.path, :password => ifile.get_password(session), :file_warning => :ignore)
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
      @encrypt = params[:encrypt].is_true?
      
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
          ApplicationRecord.transaction do
            points = 0
            for i in (s.first_row + 1)..last_row
              password = Password.new
              password.identity_id = current_user.current_identity.id

              password.password = s.cell(i, colindices[:password_column]).to_s
              password.encrypt = @encrypt

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
            Myp.modify_points(current_user, :passwords, points, session)
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
  
  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :user,
      :password,
      :email,
      :url,
      :account_number,
      :notes,
      :encrypt,
      password_secrets_attributes: [
        :id,
        :_destroy,
        :question,
        :answer
      ]
    ]
  end

  def show_share
    false
  end
  
  def password_share
    
    raise "Not implemented"
    
    set_obj
    
    if request.patch? || request.post?
      @password_share = PasswordShare.new(
        params.require(:password_share).permit(
          user_attributes: [:id]
        )
      )
      @password_share.unencrypted_password = @obj.password
      
      @obj.password_secrets.each do |password_secret|
        @password_share.password_secret_shares << PasswordSecretShare.new(
          password_secret: password_secret,
          identity: @obj.identity,
          unencrypted_answer: password_secret.answer
        )
      end
    else
      @password_share = PasswordShare.new
    end

    @password_share.password = @obj
    @password_share.identity = @obj.identity

    if request.patch? || request.post?
      ApplicationRecord.transaction do
        @password_share.save!
        
        Permission.create!(
          action: Permission::ACTION_READ,
          subject_class: PasswordShare.name.underscore.pluralize,
          subject_id: @password_share.id,
          identity_id: @password_share.identity.id,
          user_id: @password_share.user.id
        )
        
        url = LinkCreator.url("password_share_transfer", @password_share.id)
        
        share_details = I18n.t(
          "myplaceonline.passwords.share_details",
          user: @password_share.identity.display,
          time: Myp.seconds_to_time_in_general_human_detailed_hms(PasswordsController::SHARE_EXPIRE)
        )
        
        Myp.send_email(
          @password_share.user.email,
          I18n.t(
            "myplaceonline.passwords.share_subject",
            user: @password_share.identity.display
          ),
          "<p>#{share_details}</p>\n\n<p>#{ActionController::Base.helpers.link_to(url, url)}</p>".html_safe,
          nil,
          nil,
          share_details + "\n\n" + url
        )

        return redirect_to password_path(@obj),
          :flash => { :notice =>
                      I18n.t("myplaceonline.passwords.shared_sucess")
                    }
      end
    else
      render :password_share
    end
  end

  def check_password(level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    MyplaceonlineController.check_password(current_user, session, level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.general.import"),
        link: passwords_import_path,
        icon: "bars"
      }
    ]
  end
  
#   def footer_items_show
#     super + [
#       {
#         title: I18n.t("myplaceonline.general.share"),
#         link: password_password_share_path(@obj),
#         icon: "action"
#       }
#     ]
#   end
  
  protected
    def sensitive
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.passwords.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(passwords.name)", "lower(passwords.user) ASC"]
    end

    def obj_params
      params.require(:password).permit(
        PasswordsController.param_names
      )
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
        secret.encrypt = encrypt
      end
    end
    
    def settings_fields
      super + [
        {
          type: Myp::FIELD_TEXT,
          name: MAX_PASSWORD_LENGTH,
          value: @max_password_length,
          placeholder: "myplaceonline.passwords.generate_password_length"
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: USE_LOWERCASE,
          value: @use_lowercase,
          placeholder: "myplaceonline.passwords.generate_lowercase"
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: USE_UPPERCASE,
          value: @use_uppercase,
          placeholder: "myplaceonline.passwords.generate_uppercase"
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: USE_NUMBERS,
          value: @use_numbers,
          placeholder: "myplaceonline.passwords.generate_numbers"
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: USE_SPECIAL,
          value: @use_special,
          placeholder: "myplaceonline.passwords.generate_special"
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: USE_SPECIAL_ADDITIONAL,
          value: @use_special_additional,
          placeholder: "myplaceonline.passwords.generate_special_additional"
        },
      ]
    end

    def load_settings_params
      super
      @max_password_length = settings_string(name: MAX_PASSWORD_LENGTH, default_value: nil)
      @use_lowercase = settings_boolean(name: USE_LOWERCASE, default_value: true)
      @use_uppercase = settings_boolean(name: USE_UPPERCASE, default_value: true)
      @use_numbers = settings_boolean(name: USE_NUMBERS, default_value: true)
      @use_special = settings_boolean(name: USE_SPECIAL, default_value: true)
      @use_special_additional = settings_boolean(name: USE_SPECIAL_ADDITIONAL, default_value: true)
    end
end
