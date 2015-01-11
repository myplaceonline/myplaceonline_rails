class MyplaceonlineController < ApplicationController
  before_action :before_all_actions
  before_action :set_obj, only: [:show, :edit, :update, :destroy]
  skip_authorization_check :only => [:index, :new, :create]

  respond_to :html, :json

  def index
    if sensitive
      Myp.ensure_encryption_key(session)
    end
    
    Myp.visit(current_user, category_name)
    
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
    Myp.ensure_encryption_key(session)
    @obj = model.new
    new_build
    @url = new_path
    if request.post?
      return create
    else
      @encrypt = current_user.encrypt_by_default
    end
    respond_with(@obj)
  end

  def edit
    Myp.ensure_encryption_key(session)
    @url = obj_path(@obj)
    before_edit
    respond_with(@obj)
  end

  def create
    Myp.ensure_encryption_key(session)
    ActiveRecord::Base.transaction do
      @obj = model.new(obj_params)
      @obj.identity_id = current_user.primary_identity.id
      @encrypt = params[:encrypt] == "true"
      # presave *MUST* occur before create_presave or update_presave
      presave
      create_presave
      
      if @obj.save
        Myp.add_point(current_user, category_name)
        return after_create_or_update
      else
        return render :new
      end
    end
  end
  
  def update
    Myp.ensure_encryption_key(session)
    ActiveRecord::Base.transaction do

      @obj.assign_attributes(obj_params)
      @encrypt = params[:encrypt] == "true"
      # presave *MUST* occur before create_presave or update_presave
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
      format.html { redirect_to @obj }
      format.js { render :saved }
    end
  end

  def destroy
    Myp.ensure_encryption_key(session)
    before_destroy
    ActiveRecord::Base.transaction do
      @obj.destroy
      Myp.subtract_point(current_user, category_name)
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
    
    def before_all_actions
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
    
    def new_build
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

    def set_from_existing(name, model_type, destination)
      if !params[name].blank?
        id = params[name]
        i = id.rindex('/')
        if !i.nil?
          id = id[i+1..-1].to_i
          found_obj = model_type.find(id)
          authorize! :manage, found_obj
          @obj.send(destination.to_s + "=", found_obj)
        end
      end
    end
end
