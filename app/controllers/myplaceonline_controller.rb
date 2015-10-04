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
    
    @offset = params[:offset].nil? ? 0 : params[:offset].to_i
    if @offset < 0
      @offset = 0
    end
    
    @perpage = params[:perpage].nil? ? 20 : params[:perpage].to_i
    
    cached_all = all
    @count = cached_all.count
    if @perpage <= 0
      @perpage = @count
    end

    @objs = cached_all.offset(@offset).limit(@perpage).order(sorts)
    
    # If there are more items than the perpage count and we're on the first page
    # (or perpage count is 0 in which case we're showing all items), and
    # `additional_items?` returns true, then we'll add a Top X section
    
    if additional_items? && @offset == 0 && ((@perpage > 0 && @count > @perpage) || @perpage <= 0)
      @additional_items = additional_items
    end

    index_pre_respond()
    
    # Save off any query parameters which might be used by AJAX callbacks to
    # index.json.erb (for example, for a full item search)
    @query_params_part = Myp.query_parameters_uri_part(request)
    @query_params_part_all = ""
    if @query_params_part.blank?
      @query_params_part_all = "?perpage=0"
    else
      @query_params_part_all = "?" + @query_params_part + "&perpage=0"
    end
    
    @myplet = params[:myplet] == true
    if !@myplet
      respond_with(@objs)
    else
      indexmyplet
      render action: "index", layout: "myplet"
    end
  end

  def show
    if sensitive
      Myp.ensure_encryption_key(session)
    end
    before_show
    @myplet = params[:myplet] == true
    if !@myplet
      respond_with(@obj)
    else
      showmyplet
      render action: "show", layout: "myplet"
    end
  end
  
  def new
    if !insecure
      Myp.ensure_encryption_key(session)
    end
    @obj = Myp.new_model(model, params)
    @url = new_path
    if request.post?
      create
    else
      respond_with(@obj)
    end
  end

  def edit
    Myp.ensure_encryption_key(session)
    @url = obj_path(@obj)
    respond_with(@obj)
  end
  
  def create
    if !insecure
      Myp.ensure_encryption_key(session)
    end
    ActiveRecord::Base.transaction do
      begin
        p = obj_params
        Rails.logger.debug("Permitted parameters: #{p.inspect}")
        @obj = model.new(p)
      rescue ActiveRecord::RecordNotFound => rnf
        raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
      end
      
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
    update_security
    ActiveRecord::Base.transaction do

      begin
        @obj.assign_attributes(obj_params)
      rescue ActiveRecord::RecordNotFound => rnf
        raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
      end

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
  
  def second_path_name
    raise NotImplementedError
  end
  
  def category_name
    model.table_name
  end
    
  def display_obj(obj)
    obj.display
  end
    
  def model
    Object.const_get(self.class.name.gsub(/Controller$/, "").singularize)
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
  
  def new_path(context = nil)
    send("new_" + path_name + "_path")
  end
  
  # See myplaceonline_final.js, ajax:remotipartSubmit
  # 
  # If new/update succeeds, navigate JS returned in:
  # views/myplaceonline/saved.js.erb
  def may_upload
    false
  end
  
  def has_items
    @objs.length > 0 || (!@objs2.nil? && @objs2.length > 0)
  end

  def second_list_before
    false
  end
  
  def back_to_all_name
    I18n.t("myplaceonline.category." + category_name)
  end
  
  def back_to_all_path
    index_path
  end
  
  def add_another_name
    I18n.t("myplaceonline.general.add_another")
  end
  
  def second_list_icon(obj = nil)
    nil
  end
  
  def show_add
    true
  end
  
  def show_index_footer
    true
  end
  
  def how_many_top_items
    additional_items_max_items
  end
  
  def show_created_updated
    true
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
    
    def all_additional_sql
      nil
    end
    
    def all_joins
      nil
    end
    
    def all_includes
      nil
    end
    
    def additional_items?
      true
    end
  
    def additional_items_min_visit_count
      2
    end
    
    def additional_items_max_items
      5
    end
  
    def all
      additional = all_additional_sql
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".owner_id = ? " + additional,
        current_user.primary_identity.id
      )
    end
    
    def additional_items
      additional = all_additional_sql
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".owner_id = ? and " + model.table_name + ".visit_count >= ? " + additional,
        current_user.primary_identity,
        additional_items_min_visit_count
      ).limit(additional_items_max_items).order(model.table_name + ".visit_count DESC")
    end

    def set_obj
      @obj = model.find_by(id: params[:id], owner_id: current_user.primary_identity.id)
      authorize! :manage, @obj
    end
    
    def before_show
      # Use update_column because we don't want updated_at to be updated
      if @obj.visit_count?
        @obj.update_column(:visit_count, @obj.visit_count + 1)
      else
        @obj.update_column(:visit_count, 1)
      end
    end
    
    def has_category
      true
    end
    
    def index_pre_respond()
      if request.original_url().include?(".json")
        filter_json_index_search()
      end
    end
    
    def filter_json_index_search()
    end
    
    def update_security
      Myp.ensure_encryption_key(session)
    end
    
    def indexmyplet
    end
    
    def showmyplet
    end
end
