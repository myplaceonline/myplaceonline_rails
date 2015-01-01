class MyplaceonlineController < ApplicationController
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
    
    @perpage = params[:perpage].nil? ? 10 : params[:perpage].to_i
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
    ActiveRecord::Base.transaction do
      @obj = model.new(obj_params)
      @obj.identity_id = current_user.primary_identity.id
      @encrypt = params[:encrypt] == "true"
      create_presave
      
      if @obj.save
        Myp.add_point(current_user, category_name)
        redirect_to @obj
      else
        render :new
      end
    end
  end

  def update
    Myp.ensure_encryption_key(session)
    ActiveRecord::Base.transaction do

      @obj.assign_attributes(obj_params)
      @encrypt = params[:encrypt] == "true"
      update_presave

      if @obj.save
        redirect_to @obj
      else
        render :edit
      end
    end
  end

  def destroy
    Myp.ensure_encryption_key(session)
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
    
    def create_presave
    end
    
    def update_presave
    end
    
    def before_edit
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
end
