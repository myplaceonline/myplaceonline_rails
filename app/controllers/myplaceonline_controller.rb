class MyplaceonlineController < ApplicationController
  before_action :before_all_actions
  before_action :set_obj, only: [:show, :edit, :update, :destroy]
  
  DEFAULT_SKIP_AUTHORIZATION_CHECK = [:index, :new, :create]
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK

  respond_to :html, :json

  def index
    if sensitive
      Myp.ensure_encryption_key(session)
    end
    
    if has_category
      Myp.visit(current_user, category_name)
    end
    
    @count = all.count
    
    @offset = params[:offset].nil? ? 0 : params[:offset].to_i
    if @offset < 0
      @offset = 0
    end
    
    @perpage = params[:perpage].nil? ? 20 : params[:perpage].to_i
    if @perpage <= 0
      @perpage = @count
    end
    
    @objs = all.offset(@offset).limit(@perpage).order(sorts)
    
    respond_with(@objs)
  end

  def show
    if sensitive
      Myp.ensure_encryption_key(session)
    end
    respond_with(@obj)
  end

  def new
    if !insecure
      Myp.ensure_encryption_key(session)
    end
    @obj = Myp.new_model(model)
    new_obj_initialize
    @url = new_path
    if request.post?
      create
    else
      if @obj.respond_to?("encrypt")
        @obj.encrypt = current_user.encrypt_by_default
      end
      respond_with(@obj)
    end
  end

  def edit
    Myp.ensure_encryption_key(session)
    @url = obj_path(@obj)
    before_edit
    respond_with(@obj)
  end

  def create
    if !insecure
      Myp.ensure_encryption_key(session)
    end
    ActiveRecord::Base.transaction do
      begin
        @obj = model.new(obj_params)
      rescue ActiveRecord::RecordNotFound => rnf
        raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
      end
      # presave *MUST* occur before create_presave and update_presave
      presave
      create_presave
      
      if @obj.save
        if has_category
          Myp.add_point(current_user, category_name)
        end
        return after_create_or_update
      else
        return render :new
      end
    end
  end
  
  def update
    Myp.ensure_encryption_key(session)
    ActiveRecord::Base.transaction do

      begin
        @obj.assign_attributes(obj_params)
      rescue ActiveRecord::RecordNotFound => rnf
        raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
      end
      # presave *MUST* occur before create_presave and update_presave
      presave
      update_presave

      if @obj.save
        return after_create_or_update
      else
        return render :edit
      end
    end
  end
  
  def after_create_or_update
    respond_to do |format|
      format.html { redirect_to_obj }
      format.js { render :saved }
    end
  end
  
  def redirect_to_obj
    redirect_to @obj
  end

  def destroy
    Myp.ensure_encryption_key(session)
    before_destroy
    ActiveRecord::Base.transaction do
      @obj.destroy
      if has_category
        Myp.subtract_point(current_user, category_name)
      end
    end

    redirect_to index_path
  end

  def path_name
    model.model_name.singular.to_s.downcase
  end
  
  def paths_name
    path_name.pluralize
  end
  
  def category_name
    model.table_name
  end
    
  def display_obj(obj)
    raise NotImplementedError
  end
    
  def model
    raise NotImplementedError
  end
  
  def index_path
    send(paths_name + "_path")
  end
  
  def obj_path(obj = @obj)
    send(path_name + "_path", obj)
  end
  
  def edit_obj_path(obj = @obj)
    send("edit_" + path_name + "_path", obj)
  end
  
  def new_path
    send("new_" + path_name + "_path")
  end
  
  def may_upload
    false
  end

  protected
  
    def obj_params
      raise NotImplementedError
    end
    
    def sorts
      raise NotImplementedError
    end
    
    def sensitive
      false
    end
    
    def insecure
      false
    end
    
    def before_all_actions
    end
    
    def new_obj_initialize
    end
    
    # presave *MUST* occur before create_presave or update_presave
    def presave
    end
    
    def create_presave
    end
    
    def update_presave
    end
    
    def before_edit
    end
    
    def before_destroy
    end
    
    def all
      model.where(
        identity_id: current_user.primary_identity.id
      )
    end
  
    def set_obj
      @obj = model.find_by(id: params[:id], identity_id: current_user.primary_identity.id)
      authorize! :manage, @obj
    end

    # Make sure that each element in ${target}.${method} has a
    # ${belongs_to_name}_id field with a value equal to ${target}.id
    def check_nested_attributes(target, method, belongs_to_name)
      target.send(method).each {
        |attr|
        if attr.send((belongs_to_name.to_s + "_id").to_sym) != target.id
          raise "Unauthorized"
        end
      }
    end

    def select_or_create_permit(parent_name, name, all_array)
      if params[parent_name] && params[parent_name][name] && params[parent_name][name][:id].blank?
        # Push :id on even though we know it's blank to avoid the unpermitted parameter warning
        { name => all_array.push(:id) }
      else
        { name => [:id] }
      end
    end
    
    def has_category
      true
    end
end
