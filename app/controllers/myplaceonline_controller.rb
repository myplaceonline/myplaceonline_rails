class MyplaceonlineController < ApplicationController
  before_action :before_all_actions
  before_action :set_obj, only: [:show, :edit, :update, :destroy]
  before_action :set_layout
  
  DEFAULT_SKIP_AUTHORIZATION_CHECK = [:index, :new, :create, :destroy_all, :settings, :public, :most_visited, :map]
  
  CHECK_PASSWORD_REQUIRED = 1
  CHECK_PASSWORD_OPTIONAL = 2
  
  SETTING_ALWAYS_EXPAND_FAVORITES = :always_expand_favorites
  SETTING_ALWAYS_EXPAND_TOP_USED = :always_expand_top_used
  SETTING_DEFAULT_SORT = :default_sort
  SETTING_DEFAULT_SORT_DIRECTION = :default_sort_direction
  
  PARAM_OFFSET = :offset
  PARAM_PER_PAGE = :perpage
  
  DEFAULT_PER_PAGE = 20
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK

  respond_to :html, :json, :xml
  
  def set_layout
    self.class.layout(params[:no_layout] ? "blank" : "application")
  end

  def index
    initial_checks(edit: false, require_logged_in: false)
    
    if sensitive
      check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    end
    
    @myplet = params[:myplet]
    @archived = param_bool(:archived)
    @dynamic_homepage = params[:dynamic_homepage]
    Rails.logger.debug{"MyplaceonlineController.index @myplet: #{@myplet}, @dynamic_homepage: #{@dynamic_homepage}"}

    if has_category && params[:myplet].nil? && !User.current_user.guest?
      Myp.visit(User.current_user, category_name)
    end
    
    @offset = items_offset

    @perpage = items_per_page
    
    set_parent

    process_filters
    
    @count_all = all(strict: true).count
    cached_all = all
    @count = cached_all.count

    prepare_filtered_count
    
    @perpage = update_items_per_page(@perpage, @count)
    
    @items_next_page_link = items_next_page(@offset + @perpage)
    @items_previous_page_link = items_previous_page(@offset - @perpage)
    @items_all_link = items_all_link

    Rails.logger.debug{"MyplaceonlineController.index getting @objs"}
    @objs = cached_all.offset(@offset).limit(@perpage).order(Arel.sql(sorts_wrapper.join(", ")))
    
    # If the controller wants to show top items (`additional_items?` returns
    # true), then the only other thing we'll check is if there's more than
    # a few items
    if additional_items? && @count > 1
      @additional_items = additional_items
      @additional_items_count = @additional_items.count
      @additional_items = @additional_items.limit(additional_items_max_items).order(additional_items_sort)
    end

    if favorite_items? && @count > 1
      @favorite_items = favorite_items
      @favorite_items_count = @favorite_items.count
      @favorite_items = @favorite_items.limit(favorite_items_max_items).order(favorite_items_sort)
    end

    index_pre_respond()

    @query_params_part_all = items_query_params_part_all
    
    if !@myplet
      respond_with(@objs)
    else
      indexmyplet
      render action: "index", layout: "myplet"
    end
  end

  def process_filters
    Rails.logger.debug{"MyplaceonlineController.process_filters: #{simple_index_filters}"}
    simple_index_filters.each do |simple_index_filter|
      Rails.logger.debug{"MyplaceonlineController.process_filters setting #{simple_index_filter[:name].to_s} = #{param_bool(simple_index_filter[:name])}"}
      instance_variable_set("@#{simple_index_filter[:name].to_s}", param_bool(simple_index_filter[:name]))
    end
    Rails.logger.debug{"MyplaceonlineController.process_filters: #{enum_index_filters}"}
    enum_index_filters.each do |enum_index_filter|
      Rails.logger.debug{"MyplaceonlineController.process_filters setting #{enum_index_filter[:name].to_s} = #{params[enum_index_filter[:name]]}"}
      instance_variable_set("@#{enum_index_filter[:name].to_s}", params[enum_index_filter[:name]])
    end
  end
  
  def prepare_filtered_count
    # Special case: If the request is for a vanilla index page (no filters), then check if there are any items that are
    # filtered. If not, then don't bother even showing the filter section. This is to avoid the most common case of 0
    # archived items
    @filtered_count = -1
    filters = index_filters
    if filters.length == 1 && filters[0][:name] == :archived && request.query_parameters.length == 0 && @count_all == @count
      @filtered_count = 0
    end
  end

  def items_offset
    result = params[PARAM_OFFSET].nil? ? get_default_offset : params[PARAM_OFFSET].to_i
    if result < 0
      result = 0
    end
    result
  end
  
  def items_per_page
    if params[PARAM_PER_PAGE].nil?
      result = default_items_per_page
      if !User.current_user.items_per_page.nil?
        result = User.current_user.items_per_page.to_i
      end
      
      if MyplaceonlineExecutionContext.offline?
        result = 0
      end
    else
      result = params[PARAM_PER_PAGE].to_i
    end
    result
  end
  
  def update_items_per_page(perpage, count)
    if perpage <= 0
      perpage = count
    end
    perpage
  end
  
  def default_items_per_page
    DEFAULT_PER_PAGE
  end
  
  def items_query_params_part_all
    # Save off any query parameters which might be used by AJAX callbacks to
    # index.json.erb (for example, for a full item search)
    part = Myp.query_parameters_uri_part(request, [PARAM_OFFSET])
    result = ""
    if part.blank?
      result = "?perpage=0"
    else
      result = "?" + part + "&perpage=0"
    end
    result
  end
  
  def items_next_page(offset)
    get_link_target.send("#{paths_name}_path", PARAM_OFFSET => offset)
  end
  
  def items_previous_page(offset)
    get_link_target.send("#{paths_name}_path", PARAM_OFFSET => offset)
  end
  
  def items_all_link
    get_link_target.send("#{paths_name}_path")
  end
  
  def set_parent
    if nested
      parent_id = parent_table_last_name1 + "_id"
      @parent = Myp.find_existing_object(parent_model_last, params[parent_id], false)
      Rails.logger.debug{"MyplaceonlineController.set_parent parent: #{@parent.inspect} for #{parent_id} = #{params[parent_id]}"}
    end
  end

  def show
    deny_readonly_nonhtml
    if sensitive
      check_password
    end
    @no_layout = params[:no_layout]
    @nested_show = params[:nested_show]
    @nested_expanded = params[:nested_expanded]
    @nested_cell = params[:nested_cell]
    @myplet = params[:myplet]
    before_show
    if @nested_show || @no_layout
      render action: "show", layout: "blank"
    elsif !@myplet
      respond_with(@obj)
    else
      showmyplet
      render action: "show", layout: "myplet"
    end
  end
  
  def new
    
    Rails.logger.info{"MyplaceonlineController.new called with user: #{User.current_user}"}
    
    initial_checks

    if !allow_add
      raise "Unauthorized"
    end
    
    Rails.logger.info{"MyplaceonlineController.new performing initial checks"}
    
    if !insecure
      Rails.logger.info{"MyplaceonlineController.new secure: checking password"}
      check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    end
    if sensitive
      Rails.logger.info{"MyplaceonlineController.new sensitive: checking password"}
      check_password
    end
    @myplet = params[:myplet]
    @obj = Myp.new_model(model, params)
    build_new_model
    set_parent
    @url = new_path
    if request.post?
      create
    else
      new_prerespond
      Rails.logger.debug{"myplaceonline_controller new: #{@obj.inspect}"}
      
      if !@myplet
        respond_with(@obj)
      else
        render action: "new", layout: "myplet"
      end
    end
  end

  def edit
    initial_checks

    @myplet = params[:myplet]
    check_password
    @url = obj_path(@obj)
    edit_prerespond
    if !@myplet
      respond_with(@obj)
    else
      render action: "edit", layout: "myplet"
    end
  end
  
  def create
    if !allow_add
      raise "Unauthorized"
    end
    
    initial_checks
    
    Rails.logger.debug{"create"}
    if !insecure
      check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    end
    if sensitive
      check_password
    end
    ApplicationRecord.transaction do
      begin
        if @parent.nil?
          Permission.current_target = @obj
        else
          Permission.current_target = @parent
        end
        
        begin
          p = obj_params
          Rails.logger.debug{"create: permitted parameters: #{p.inspect}"}
          
          # If there's an ID, then we're actually updating instead of creating
          if p[:id].blank?
            Rails.logger.debug{"create: id blank"}
            @obj = model.new(p)
          else
            set_obj(p: p, override_existing: true)
            #Rails.logger.debug{"create: @obj before assign: #{Myp.debug_print(@obj)}"}
            @obj.assign_attributes(p)
            #Rails.logger.debug{"create: updated @obj: #{Myp.debug_print(@obj)}"}
          end
        rescue ActiveRecord::RecordNotFound => rnf
          raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
        end

        if do_check_double_post
          return after_create_redirect
        end
        
        if nested
          parent_name = parent_table_last_name2
          parent_id = parent_table_last_name1 + "_id"
          new_parent = Myp.find_existing_object(parent_model_last, params[parent_id], false)
          Rails.logger.debug{"Setting parent #{parent_id} to #{new_parent.inspect} for #{parent_name}"}
          @obj.send("#{parent_name}=", new_parent)
        end
        
        precreate
        
        save_result = @obj.save
        
        Rails.logger.debug{"Saved #{save_result.to_s} for #{@obj.inspect}"}
        
        if save_result
          
          Rails.logger.debug{"Parent: #{@parent.inspect}"}
          
          if !@parent.nil? && !@obj.current_user_owns?
            existing_permission = Permission.where(
              user_id: User.current_user.id,
              subject_class: Myp.model_to_category_name(@parent.class),
              subject_id: @parent.id
            ).first
            
            Rails.logger.debug{"Existing permission: #{existing_permission.inspect}"}
            
            if !existing_permission.nil?
              Permission.new(
                identity_id: existing_permission.identity_id,
                user_id: existing_permission.user_id,
                subject_class: Myp.model_to_category_name(model),
                subject_id: @obj.id,
                action: existing_permission.action
              ).save!
            end
          end
          if has_category
            Myp.add_point(User.current_user, category_name, session)
          end
          after_create_result = after_create
          if !after_create_result.nil?
            Rails.logger.debug{"after_create_result not nil"}
            return after_create_result
          end
          return after_create_redirect
        else
          return render :new
        end
      ensure
        Permission.current_target = nil
      end
    end
  end
  
  def update
    initial_checks
    
    if sensitive
      check_password
    end

    if do_update
      return after_update_redirect
    else
      return render :edit
    end
  end
  
  def do_check_double_post
    
    # Don't check this in test because test might quickly be creating items
    if !Rails.env.test?
      # If an item of this model type was created within the last few seconds
      # then just assume it was a double POST
      last_item = model
        .where("#{context_column} = ?", context_value)
        .order("created_at DESC")
        .limit(1)
        .first
        
      if !last_item.nil?
        if last_item.created_at + 3.seconds >= Time.now.utc
          @obj = last_item
          Rails.logger.warn{"Detected double post #{last_item.inspect}"}
          return true
        end
      end
    end
    
    false
  end
  
  def do_update(check_double_post: false)
    update_security
    
    ApplicationRecord.transaction do
      begin
        if @parent.nil?
          Permission.current_target = @obj
        else
          Permission.current_target = @parent
        end

        begin
          @obj.assign_attributes(obj_params)
        rescue ActiveRecord::RecordNotFound => rnf
          raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
        end
        
        if check_double_post
          if do_check_double_post
            return true
          end
        end
        
        do_update_before_save

        #Rails.logger.debug{"saving updated obj: #{Myp.debug_print(@obj)}"}

        @obj.save
      ensure
        Permission.current_target = nil
      end
    end
  end
  
  def do_update_before_save
  end
  
  def precreate
  end
  
  def after_create_redirect
    Rails.logger.debug{"after_create_redirect after_new_item: #{User.current_user.after_new_item}"}
    respond_to do |format|
      format.html {
        if User.current_user.after_new_item.nil? || User.current_user.after_new_item == Myp::AFTER_NEW_ITEM_SHOW_ITEM
          redirect_to_obj
        elsif User.current_user.after_new_item == Myp::AFTER_NEW_ITEM_SHOW_LIST
          redirect_to index_path
        elsif User.current_user.after_new_item == Myp::AFTER_NEW_ITEM_ANOTHER_ITEM
          redirect_to new_path
        else
          raise "TODO"
        end
      }
      format.js { render :saved }
    end
  end
  
  def after_update_redirect
    respond_to do |format|
      format.html { redirect_to_obj }
      format.js { render :saved }
    end
  end
  
  def redirect_to_obj
    redirect_to obj_path
  end

  def destroy
    initial_checks
    
    check_password
    
    obj_to_destroy = self.object_to_destroy(@obj)
    
    ApplicationRecord.transaction do
      perform_destroy(obj_to_destroy)
      if has_category
        Myp.subtract_point(User.current_user, category_name, session)
      end
    end

    redirect_to index_path
  end

  def destroy_all
    check_password
    
    initial_checks
    
    ApplicationRecord.transaction do
      all.each do |obj|
        authorize! :destroy, obj
        obj.destroy
        if has_category
          Myp.subtract_point(User.current_user, category_name, session)
        end
      end
    end

    if nested
      set_parent
      redirect_to url_for(@parent),
          :flash => { :notice => I18n.t("myplaceonline.general.all_deleted") }
    else
      redirect_to index_path,
          :flash => { :notice => I18n.t("myplaceonline.general.all_deleted") }
    end
  end
  
  def path_name
    if !model.model_name.to_s.include?("::")
      model.model_name.singular.to_s.downcase
    else
      model.model_name.to_s.split("::")[1].underscore.singularize.downcase
    end
  end
  
  def paths_name
    path_name.pluralize
  end
  
  def paths_form_name
    # Can't refactor this to use paths_name because of nested controllers
    if !model.model_name.to_s.include?("::")
      engine_link_prefix + model.model_name.singular.to_s.downcase.pluralize
    else
      engine_link_prefix + model.model_name.to_s.split("::")[1].underscore.downcase.pluralize
    end
  end
  
  def myplet_path_prefix
    if !model.model_name.to_s.include?("::")
      self.paths_name
    else
      engine_link_prefix + model.model_name.to_s.split("::")[1].underscore.downcase.pluralize
    end
  end
  
  def second_path_name
    raise NotImplementedError
  end
  
  def category
    Myp.categories[self.category_name.to_sym]
  end
  
  def engine_link_prefix
    if !model.model_name.to_s.include?("::")
      return ""
    else
      return model.model_name.to_s.split("::")[0].underscore.downcase + "/"
    end
  end
  
  def category_name
    if !model.name.include?("::")
      model.table_name
    else
      model.table_name[model.name.split("::")[0].underscore.length+1..-1]
    end
  end
    
  def display_obj(obj)
    result = obj.display
    if result.nil?
      result = HTMLEntities.new.encode(obj.to_s)
    end
    result
  end
  
  def display_obj_bubble(obj)
    if use_bubble?
      btext = bubble_text(obj)
      if !btext.blank?
        " <span class=\"ui-li-count\">#{btext}</span>"
      else
        ""
      end
    else
      ""
    end
  end
  
  def use_bubble?
    false
  end
  
  def bubble_text(obj)
    ""
  end
  
  def item_classes(obj)
    nil
  end
    
  def model
    Object.const_get(self.class.name.gsub(/Controller$/, "").singularize)
  end
  
  def get_link_target
    if !model.model_name.to_s.include?("::")
      return main_app
    else
      return send(model.model_name.to_s.split("::")[0].underscore.downcase)
    end
  end
  
  def index_path
    if nested
      get_link_target.send(paths_name + "_path", @parent)
    else
      get_link_target.send(paths_name + "_path")
    end
  end
  
  def obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_path", obj)
    end
  end
  
  def obj_url(obj = @obj)
    if nested
      get_link_target.send(path_name + "_url", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_url", obj)
    end
  end
  
  def edit_obj_path(obj = @obj)
    if nested
      get_link_target.send("edit_" + path_name + "_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send("edit_" + path_name + "_path", obj)
    end
  end
  
  def archive_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_archive_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_archive_path", obj)
    end
  end
  
  def unarchive_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_unarchive_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_unarchive_path", obj)
    end
  end
  
  def favorite_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_favorite_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_favorite_path", obj)
    end
  end
  
  def unfavorite_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_unfavorite_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_unfavorite_path", obj)
    end
  end
  
  def share_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_create_share_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_create_share_path", obj)
    end
  end
  
  def move_identity_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_move_identity_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_move_identity_path", obj)
    end
  end
  
  def share_link_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_create_share_link_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_create_share_link_path", obj)
    end
  end
  
  def make_public_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_make_public_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_make_public_path", obj)
    end
  end
  
  def remove_public_obj_path(obj = @obj)
    if nested
      get_link_target.send(path_name + "_remove_public_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send(path_name + "_remove_public_path", obj)
    end
  end
  
  def show_path(obj)
    if nested
      get_link_target.send("#{path_name}_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      get_link_target.send("#{path_name}_path", obj)
    end
  end
  
  def new_path(context = nil)
    if nested
      get_link_target.send("new_" + path_name + "_path", @parent)
    else
      get_link_target.send("new_" + path_name + "_path")
    end
  end
  
  def settings_path()
    get_link_target.send("#{paths_name}_settings_path")
  end
  
  def destroy_all_path(context = nil)
    if nested
      set_parent
      get_link_target.send("#{path_name.pluralize}_destroy_all_path", @parent)
    else
      get_link_target.send("#{path_name.pluralize}_destroy_all_path")
    end
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
    category_display
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
  
  def allow_add
    if !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
      if category.nil?
        true
      else
        if category.user_type_mask.nil?
          true
        else
          if current_user.user_type.nil?
            false
          else
            if (current_user.user_type & category.user_type_mask) == category.user_type_mask
              true
            else
              false
            end
          end
        end
      end
    else
      false
    end
  end
  
  def allow_edit
    !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
  end
  
  def show_add
    allow_add
  end
  
  def show_move_identity
    !User.current_user.guest? && !MyplaceonlineExecutionContext.offline? && current_user.domain_identities.count > 1
  end
  
  def show_back_to_list
    !User.current_user.guest?
  end
  
  def show_index_add
    allow_add
  end
  
  def show_index_settings
    true
  end
  
  def show_edit
    allow_edit
  end
  
  def obj_locked?
    result = false
    if @obj.respond_to?("read_only?") && @obj.read_only?(action: nil)
      result = true
    end
    result
  end
  
  def show_index_footer
    !User.current_user.guest?
  end
  
  def how_many_top_items
    additional_items_max_items
  end
  
  def show_created_updated
    User.current_user.show_timestamps
  end
  
  def form_path
    engine_link_prefix + paths_name + "/form"
  end
  
  def new_title
    I18n.t("myplaceonline.general.add") + " " + (category.nil? ? category_display.singularize : category.human_title_singular)
  end
  
  def data_split_icon
    "check"
  end
  
  def split_link(obj)
    ""
  end
  
  def new_save_text
    I18n.t("myplaceonline.general.save") + " " + (category.nil? ? category_display.singularize : category.human_title_singular)
  end
  
  def index_destroy_all_link?
    false
  end
  
  def index_settings_link?
    has_category && !MyplaceonlineExecutionContext.offline?
  end
  
  def search_index_name
    category_name
  end
  
  def search_parent_category
    nil
  end
  
  def search_filters_model
    nil
  end
  
  def search_public?
    User.current_user.guest?
  end
  
  def share_permissions
    [Permission::ACTION_READ]
  end
  
  def nested
    false
  end
  
  def show_share
    !nested && !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
  end
  
  def self.check_password(user, session, level: MyplaceonlineController::CHECK_PASSWORD_REQUIRED)
    requires_check = true
    if level == MyplaceonlineController::CHECK_PASSWORD_OPTIONAL && user.minimize_password_checks
      requires_check = false
    end
    if requires_check
      Myp.get_current_user_password!
    end
  end
  
  def index_sorts
    result = []

    result << [I18n.t("myplaceonline.general.created_at"), "#{model.table_name}.created_at"]
    result << [I18n.t("myplaceonline.general.updated_at"), "#{model.table_name}.updated_at"]
    
    if !User.current_user.guest?
      result << [I18n.t("myplaceonline.general.visit_count"), "#{model.table_name}.visit_count"]
    end

    ds = additional_sorts
    if !ds.nil?
      result = ds + result
    end
    result
  end
  
  def default_sort_columns
    ["#{model.table_name}.updated_at"]
  end
  
  def default_sort_direction
    if default_sort_columns[0] == "#{model.table_name}.updated_at"
      "desc"
    else
      "asc"
    end
  end
  
  def default_sorts_additions
    "nulls last"
  end

  def sorts_helper
    @selected_sort_direction = params[:selected_sort_direction]
    
    if @selected_sort_direction.blank?
      @selected_sort_direction = Setting.get_value(
        category: self.category,
        name: SETTING_DEFAULT_SORT_DIRECTION,
      )
    end
    
    if @selected_sort_direction.blank?
      @selected_sort_direction = default_sort_direction
    elsif @selected_sort_direction.downcase != "asc" && @selected_sort_direction.downcase != "desc"
      @selected_sort_direction = default_sort_direction
    else
      @selected_sort_direction = @selected_sort_direction.downcase
    end
    
    if Myp.param_bool(params, :reverse, default_value: false)
      if @selected_sort_direction.downcase == "asc"
        @selected_sort_direction = "desc"
      else
        @selected_sort_direction = "asc"
      end
    end
    
    dsc = nil
    @selected_sort = params[:selected_sort]
    
    if @selected_sort.blank?
      @selected_sort = Setting.get_value(
        category: self.category,
        name: SETTING_DEFAULT_SORT,
      )
    end
    
    if !@selected_sort.blank?
      @selected_sort = @selected_sort.gsub(/[^a-zA-Z\._\(\)]/, "")
    else
      dsc = default_sort_columns
      @selected_sort = dsc[0]
    end
    
    result = ["#{@selected_sort} #{@selected_sort_direction} #{default_sorts_additions}"]
    
    Rails.logger.debug{"MyplaceonlineController.sorts_helper sorting by #{@selected_sort} #{@selected_sort_direction} #{default_sorts_additions}"}
    
    if !dsc.nil? && dsc.length > 1
      result = result + dsc.drop(1)
    end
    
    result
  end

  def footer_items_index
    result = []
    if self.show_index_add
      result << {
        title: I18n.t("myplaceonline.general.add") + " " + (category.nil? ? category_display.singularize : category.human_title_singular),
        link: self.new_path,
        icon: "plus"
      }
    end
    if self.index_destroy_all_link? && !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.general.delete_all"),
        link: self.destroy_all_path,
        icon: "delete"
      }
    end
    if self.index_settings_link? && !User.current_user.guest?
      result << {
        title: I18n.t("myplaceonline.general.settings"),
        link: self.settings_path,
        icon: "gear"
      }
    end
    if self.show_map? && !MyplaceonlineExecutionContext.offline?
      result << map_link
    end
    result
  end
  
  def footer_items_map
    result = []

    result << {
      content: ActionController::Base.helpers.submit_tag(I18n.t("myplaceonline.general.update"), "data-icon" => "action", "data-iconpos" => "top")
    }
    
    if self.show_index_add
      result << {
        title: I18n.t("myplaceonline.general.add") + " " + (category.nil? ? category_display.singularize : category.human_title_singular),
        link: self.new_path,
        icon: "plus"
      }
    end

    result << {
      title: I18n.t("myplaceonline.general.list", category: category.nil? ? category_display : category.human_title),
      link: index_path,
      icon: "bars"
    }

    result
  end
  
  def footer_items_show
    result = []
    if show_edit && !obj_locked?
      result << {
        title: I18n.t("myplaceonline.general.edit"),
        link: self.edit_obj_path,
        icon: "edit"
      }
    end
    if self.show_back_to_list
      result << {
        title: I18n.t("myplaceonline.general.back_to_list"),
        link: self.back_to_all_path,
        icon: "back"
      }
    end
    if self.show_map? && !MyplaceonlineExecutionContext.offline?
      result << map_link
    end
    if @obj.respond_to?("is_archived?") && (!nested || !parent_model.is_a?(Array)) && !obj_locked? && self.show_archive_button && !MyplaceonlineExecutionContext.offline?
      if @obj.is_archived?
        result << {
          title: I18n.t("myplaceonline.general.unarchive"),
          link: self.unarchive_obj_path,
          icon: "plus"
        }
      else
        result << {
          title: I18n.t("myplaceonline.general.archive"),
          link: self.archive_obj_path,
          icon: "minus"
        }
      end
    end
    if self.show_add
      result << {
        title: self.add_another_name,
        link: self.new_path(@obj),
        icon: "plus"
      }
    end
    if self.show_share && !obj_locked?
      result << {
        title: I18n.t("myplaceonline.general.share"),
        link: self.share_obj_path,
        icon: "action"
      }
    end
    if @obj.respond_to?("rating") && (!nested || !parent_model.is_a?(Array)) && !obj_locked? && self.show_favorite_button
      if @obj.rating.nil? || @obj.rating < Myp::MAX_RATING
        result << {
          title: I18n.t("myplaceonline.general.favorite"),
          link: self.favorite_obj_path,
          icon: "star"
        }
      else
        result << {
          title: I18n.t("myplaceonline.general.unfavorite"),
          link: self.unfavorite_obj_path,
          icon: "back"
        }
      end
    end
    if !obj_locked? && show_delete
      result << {
        title: I18n.t("myplaceonline.general.delete"),
        link: self.obj_path,
        icon: "delete",
        method: :delete,
        data: { confirm: "Are you sure?" }
      }
    end
    if self.show_move_identity
      result << {
        title: I18n.t("myplaceonline.general.move_identity"),
        link: self.move_identity_obj_path,
        icon: "user"
      }
    end
    result
  end
  
  def archive(notice: I18n.t("myplaceonline.general.archived"))
    initial_checks
    set_obj
    
    @obj.archive!
    
    redirect_to index_path,
      :flash => { :notice => notice }
  end
  
  def unarchive(notice: I18n.t("myplaceonline.general.unarchived"))
    initial_checks
    set_obj
    @obj.update_column(:archived, nil)
    redirect_to index_path,
      :flash => { :notice => notice }
  end
  
  def favorite(notice: I18n.t("myplaceonline.general.favorited"))
    initial_checks
    set_obj
    @obj.update_column(:rating, Myp::MAX_RATING)
    redirect_to obj_path,
      :flash => { :notice => notice }
  end
  
  def unfavorite(notice: I18n.t("myplaceonline.general.unfavorited"))
    initial_checks
    set_obj
    @obj.update_column(:rating, nil)
    redirect_to obj_path,
      :flash => { :notice => notice }
  end
  
  def create_share
    initial_checks
    set_obj
    
    @connections_link = permissions_share_path + "?" + Permission.permission_params(self.category_name, @obj.id, self.share_permissions).to_query
  end
  
  def move_identity
    initial_checks
    set_obj
    
    if request.post?
      
      target_identity_id = params["target_identity_id"].to_i
      target_identity = User.current_user.domain_identities.find{|x| x.id == target_identity_id}
      if !target_identity.nil?
        @obj.update_column(:identity_id, target_identity_id)
        redirect_to(
          index_path,
          flash: { notice: I18n.t("myplaceonline.general.moved_identity") }
        )
      end
    end
  end
  
  def make_public
    initial_checks
    set_obj
    
    if !has_public_permission?
      @obj.is_public = true
      @obj.save!
    end

    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.general.made_public", link: obj_url) }
    )
  end
  
  def has_public_permission?
    @obj.is_public?
  end
  
  def remove_public
    initial_checks
    set_obj
    
    @obj.is_public = false
    @obj.save!
    
    redirect_to(
      obj_path,
      flash: { notice: I18n.t("myplaceonline.general.removed_public", link: obj_url) }
    )
  end
  
  def create_share_link
    initial_checks
    set_obj
    
    existing_permission_share = PermissionShare.includes(:share).where(
      identity: User.current_user.current_identity,
      subject_class: self.model.name,
      subject_id: @obj.id
    ).first
    
    if existing_permission_share.nil?
      share = Share.build_share(owner_identity: User.current_user.current_identity)
      share.save!
      
      PermissionShare.create!(
        identity: User.current_user.current_identity,
        share: share,
        subject_class: self.model.name,
        subject_id: @obj.id,
        valid_guest_actions: self.publicly_shareable_actions.map{|x| x.to_s}.join(",")
      )
      
      token = share.token
    else
      token = existing_permission_share.share.token
    end
    @link = "#{obj_url}?token=#{token}"
  end
  
  def index_filters
    result = []
    
    if !User.current_user.guest?
      result << {
        :name => :archived,
        :display => "myplaceonline.general.archived"
      }
    end
    
    simple_index_filters.each do |simple_index_filter|
      result << {
        :name => simple_index_filter[:name],
        :display => simple_index_filter[:display].blank? ? index_filter_translate(simple_index_filter[:name].to_s) : simple_index_filter[:display],
      }
    end
    
    enum_index_filters.each do |enum_index_filter|
      result << {
        :name => enum_index_filter[:name],
        :display => enum_index_filter[:display],
        :select_options => enum_index_filter[:select_options],
      }
    end
    
    result
  end
  
  def index_filter_translate(name)
    "myplaceonline.#{category_name}.#{name}"
  end
  
  def show_search
    !MyplaceonlineExecutionContext.offline?
  end
  
  def show_favorites
    !User.current_user.guest?
  end
  
  def show_favorite_button
    !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
  end
  
  def show_archive_button
    !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
  end
  
  def show_delete
    !User.current_user.guest? && !MyplaceonlineExecutionContext.offline?
  end
  
  def show_additional
    true
  end
  
  def show_add_button
    @myplet && !MyplaceonlineExecutionContext.offline?
  end
  
  def myplet_title_linked?
    true
  end
  
  def myplet_title
    result = @myplet.display
    if myplet_title_linked?
      result = ActionController::Base.helpers.link_to(result, @myplet.link)
    end
    result
  end
  
  def settings_boolean(name:, default_value: false)
    Myp.param_bool(
      params,
      name,
      default_value:
        Setting.get_value_boolean(
          category: self.category,
          name: name,
          default_value: default_value
        )
    )
  end
  
  def settings_string(name:, default_value: nil, settings_category: nil)
    result = params[name]
    if result.blank?
      if settings_category.nil?
        settings_category = self.category
      end
      result = Setting.get_value(
        category: settings_category,
        name: name,
        default_value: default_value
      )
    end
    result
  end
  
  def settings
    initial_checks
    
    check_password

    load_settings_params
    
    @fields = settings_fields
    
    if request.post?
      
      @fields.each do |field|
        
        case field[:type]
        when Myp::FIELD_BOOLEAN
          value = Myp.param_bool(
            params,
            field[:name]
          )
        when Myp::FIELD_TEXT, Myp::FIELD_SELECT
          value = params[field[:name]]
        else
          raise "TODO"
        end
        
        Rails.logger.debug{"MyplaceonlineController.settings setting #{self.category.human_title}.#{field[:name]} = #{value}"}
        
        Setting.set_value(
          category: self.category,
          name: field[:name],
          value: value
        )
      end
      
      redirect_to(
        index_path,
        flash: { notice: I18n.t("myplaceonline.general.settings_saved") }
      )
    end
  end
  
  def additional_items_collapsed
    if !defined?(@cached_additional_items_collapsed)
      @cached_additional_items_collapsed = !Setting.get_value_boolean(category: self.category, name: SETTING_ALWAYS_EXPAND_TOP_USED)
    end
    @cached_additional_items_collapsed
  end
  
  def favorite_items_collapsed
    if !defined?(@cached_favorite_items_collapsed)
      @cached_favorite_items_collapsed = !Setting.get_value_boolean(category: self.category, name: SETTING_ALWAYS_EXPAND_FAVORITES)
    end
    @cached_favorite_items_collapsed
  end
  
  def autofocus_search
    self.additional_items_collapsed && self.favorite_items_collapsed
  end
  
  def show_wrap
    true
  end
  
  def heading_prefix_category
    true
  end
  
  def sort_options
    [
      [t("myplaceonline.general.ascending"), "asc"],
      [t("myplaceonline.general.descending"), "desc"],
    ]
  end
  
  def top_content
    nil
  end

  def form_menu_items(form, new:)
    main_button = new ? new_save_text : I18n.t("myplaceonline.general.save") + " " + (category.nil? ? category_display.singularize : category.human_title_singular)
    
    result = []

    if !MyplaceonlineExecutionContext.offline?
      result << {
        content: form.submit(main_button, "data-icon" => "action", "data-iconpos" => "top", "style" => "background-color: green")
      }
    end
    
    if form_menu_items_cancel?
      result << {
        title: I18n.t("myplaceonline.general.cancel"),
        link: new ? index_path : obj_path,
        icon: "back"
      }
    end
    
    result
  end

  def public
    @myplet = params[:myplet]
    if !@myplet
      render action: "public"
    else
      render action: "public", layout: "myplet"
    end
  end
  
  def before_show_view
    false
  end
  
  def use_custom_heading
    false
  end
  
  def custom_heading
    nil
  end
  
  def most_visited
    result = self.all.order("visit_count DESC").limit(1).take
    if !result.nil?
      redirect_to(obj_path(result))
    else
      redirect_to(index_path)
    end
  end

  def map
    process_filters
    
    items = self.map_items
    
    @count_all = items.count
    
    @locations = items.map{ |x|
      result = nil
      if self.has_location?(x)
        loc = self.get_map_location(x)
        if !loc.nil? && loc.ensure_gps
          label = nil
                                       
          if self.map_driving_time? && loc.estimate_driving_time && loc.time_from_home < 86400
            label = (loc.time_from_home/60.0).ceil.to_s
          end
          
          popupHtml = "<p>#{ActionController::Base.helpers.link_to(x.display, obj_path(x))}</p><ul><li>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.maps.full_map"), loc.map_url(prefer_human_readable: false), target: "_blank", class: "externallink")}</li><li>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.maps.directions"), loc.map_directions_url(from_current_location: true, autostart: true), target: "_blank", class: "externallink")}</li></ul>"
          
          dotless = true
          icon = "red"
          labelColor = "#ffffff"
          ontop = false
          
          if x.respond_to?("rating") && !x.rating.nil?
            case x.rating
            when 0
              icon = "white"
              labelColor = "#000000"
            when 1
              icon = "grey"
              labelColor = "#000000"
            when 2
              icon = "yellow"
              labelColor = "#000000"
            when 3
              icon = "red"
              labelColor = "#ffffff"
            when 4
              icon = "blue"
              labelColor = "#ffffff"
            when 5
              icon = "green"
              labelColor = "#ffffff"
              ontop = true
            end
          end
          
          if dotless
            icon << "_dotless"
          end
          
          result = MapLocation.new(
            latitude: loc.latitude,
            longitude: loc.longitude,
            label: label,
            tooltip: x.display,
            popupHtml: popupHtml,
            icon: icon,
            labelColor: labelColor,
            ontop: ontop,
          )
        end
      end
      result
    }.compact
    
    @count = @locations.count
    
    Rails.logger.debug{"MyplaceonlineController.map items: #{@count}"}
    
    prepare_filtered_count
  end
  
  def category_display
    category.nil? ? I18n.t("myplaceonline.category." + self.category_name) : category.human_title
  end
  
  def all_items
    self.all
  end
  
  def use_simple_search
    false
  end
  
  protected
  
    def deny_guest
      if User.current_user.guest?
        Rails.logger.debug{"Denying guest access"}
        raise CanCan::AccessDenied
      end
    end
    
    def deny_nonadmin
      if !User.current_user.admin?
        raise CanCan::AccessDenied
      end
    end
    
    def deny_readonly_nonhtml
      if !request.format.html? && request.format.to_s != "*/*" && !Ability.authorize(identity: User.current_user.domain_identity, subject: @obj, action: :edit, request: request)
        Rails.logger.debug{"Denying #{request.format.inspect}"}
        raise CanCan::AccessDenied
      end
    end
    
    def require_admin?
      false
    end
  
    def obj_params
      raise NotImplementedError
    end
    
    def additional_sorts
      nil
    end
    
    def sorts_wrapper
      sorts_helper
    end
    
    def sensitive
      false
    end
    
    def insecure
      false
    end
    
    def before_all_actions
      if requires_admin && !User.current_user.admin?
        raise CanCan::AccessDenied
      end
    end
    
    def check_archived
      true
    end
    
    def perform_destroy(obj)
      obj.destroy!
    end
    
    def additional_sql_simple_index_filters(result)
      simple_index_filters.each do |simple_index_filter|
        if !simple_index_filter[:column]
          colname = simple_index_filter[:name].to_s
        else
          colname = simple_index_filter[:column].to_s
        end
        
        Rails.logger.debug{"all_additional_sql simple_index_filter: #{colname}"}
        
        if !instance_variable_get("@#{simple_index_filter[:name].to_s}").nil?
          if instance_variable_get("@#{simple_index_filter[:name].to_s}")
            if !simple_index_filter[:inverted]
              sql = "#{model.table_name}.#{colname} = true"
            else
              sql = "#{model.table_name}.#{colname} is null or #{model.table_name}.#{colname} = false"
            end
            Rails.logger.debug{"all_additional_sql sql: #{sql}"}
            result = Myp.appendstr(
              result,
              sql,
              nil,
              " and (",
              ")"
            )
          else
            if !simple_index_filter[:inverted]
              sql = "#{model.table_name}.#{colname} = false"
            else
              sql = "#{model.table_name}.#{colname} = true"
            end
            Rails.logger.debug{"all_additional_sql sql: #{sql}"}
            result = Myp.appendstr(
              result,
              sql,
              nil,
              " and (",
              ")"
            )
          end
        end
      end
      enum_index_filters.each do |enum_index_filter|
        colname = enum_index_filter[:name].to_s
        
        Rails.logger.debug{"all_additional_sql enum_index_filter: #{colname}"}
        
        if !instance_variable_get("@#{enum_index_filter[:name].to_s}").blank?
          sql = "#{model.table_name}.#{colname} = #{ActiveRecord::Base.connection.quote(instance_variable_get("@#{enum_index_filter[:name].to_s}"))}"
          Rails.logger.debug{"all_additional_sql sql: #{sql}"}
          result = Myp.appendstr(
            result,
            sql,
            nil,
            " and (",
            ")"
          )
        end
      end
      return result
    end
    
    def all_additional_sql(strict)
      result = nil
      Rails.logger.debug{"all_additional_sql strict: #{strict}"}
      if !strict
        if check_archived && (@archived.blank? || !@archived)
          result = Myp.appendstr(result, "#{model.table_name}.archived is null", nil, " and (", ")")
        end
        result = additional_sql_simple_index_filters(result)
      end
      result
    end
    
    def all_joins
      nil
    end
    
    def all_includes
      nil
    end
    
    def additional_items?
      model.new.respond_to?("visit_count")
    end
  
    def favorite_items?
      additional_items?
    end
  
    def additional_items_min_visit_count
      2
    end
    
    def additional_items_max_items
      5
    end
    
    def favorite_items_max_items
      100
    end
    
    def find_explicit_items
      Permission.where(
        "user_id = ? and subject_class = ? and (action & #{Permission::ACTION_MANAGE} != 0 or action & #{Permission::ACTION_READ} != 0)",
        User.current_user.id,
        category_name
      ).to_a.map{|p| p.subject_id}
    end

    # strict: true allows getting all items (usually for a total count)
    def all(strict: false)
      initial_or = ""
      can_read_others = find_explicit_items
      if !can_read_others.blank?
        initial_or = " or #{model.table_name}.id in (#{can_read_others.join(",")})"
      end
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      if nested
        parent_id1 = parent_table_last_name1 + "_id"
        parent_id2 = parent_table_last_name2 + "_id"
        additional += " AND #{model.table_name}.#{parent_id2} = #{ActiveRecord::Base.connection.quote(params[parent_id1.to_sym])}"
      end
      Rails.logger.debug{"all query strict: #{strict}, additional: #{additional}"}
      perform_all(initial_or: initial_or, additional: additional)
    end
    
    def context_column
      "identity_id"
    end
    
    def context_value
      User.current_user.current_identity.id
    end
    
    def perform_all(initial_or:, additional:)
      if User.current_user.guest?
        model.includes(all_includes).joins(all_joins).where(
          "(#{model.table_name}.is_public = ? #{initial_or}) #{additional}",
          true
        )
      elsif (User.current_user.admin? && self.admin_sees_all?) || self.nonadmin_sees_all?
        model.includes(all_includes).joins(all_joins).where(
          "(true #{initial_or}) #{additional}"
        )
      else
        model.includes(all_includes).joins(all_joins).where(
          "(#{model.table_name}.#{context_column} = ? #{initial_or}) #{additional}",
          context_value
        )
      end
    end
    
    def additional_items(strict: false)
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".#{context_column} = ? and " + model.table_name + ".visit_count >= ? " + additional,
        context_value,
        additional_items_min_visit_count
      )
    end

    def additional_items_sort
      model.table_name + ".visit_count DESC"
    end

    def favorite_items(strict: false)
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".#{context_column} = ? and " + model.table_name + ".rating = ? " + additional,
        context_value,
        Myp::MAX_RATING
      )
    end
    
    def favorite_items_sort
      model.table_name + ".visit_count DESC"
    end

    def set_obj(action = nil, p: params, override_existing: false)
      Rails.logger.debug{"MyplaceonlineController.set_obj action: #{action}, p: #{p.inspect}"}
      if action.nil?
        action = action_name
      end

      # First lookup, then authorize
      begin
        if nested
          parent_id1 = parent_table_last_name1 + "_id"
          parent_id2 = parent_table_last_name2 + "_id"
          Rails.logger.debug{"MyplaceonlineController.set_obj parent_id: #{parent_id1}, param: #{p[parent_id1]}"}
          if !p[parent_id1].nil?
            @parent = Myp.find_existing_object(parent_model_last, p[parent_id1], false)
            Rails.logger.debug{"MyplaceonlineController.set_obj parent: #{@parent.inspect}"}
            @obj = model.where("id = ? and #{parent_id2} = ?", p[:id].to_i, p[parent_id1.to_sym].to_i).take!
          end
        end
        if @obj.nil? || override_existing
          @obj = model.where(id: p[:id].to_i).order(nil).limit(1).first
          
          if @obj.nil?
            handle_object_not_found(p[:id])
          end
          
          Rails.logger.debug{"MyplaceonlineController.set_obj setting @obj: #{@obj}"}
        end
      rescue ActiveRecord::RecordNotFound => rnf
        Rails.logger.debug{"MyplaceonlineController.set_obj caught #{rnf}"}
        raise Myp::SuddenRedirectError.new(index_path)
      end
      
      authorize! action.to_sym, @obj
      
      if @obj.respond_to?("identity_id")        
        # If this succeeds, then set the identity context for nested authorization checks
        Rails.logger.debug{"MyplaceonlineController.set_obj setting Ability.context_identity = #{@obj.identity_id}"}
        Ability.context_identity = @obj.identity
      end
    end
    
    def handle_object_not_found(id)
      raise ActiveRecord::RecordNotFound
    end
    
    def before_show
      # Use update_column because we don't want updated_at to be updated
      if params[:myplet].nil?
        MyplaceonlineController.increment_visit_count(@obj)
      end
    end
    
    def self.increment_visit_count(obj)
      if obj.respond_to?("visit_count") && !MyplaceonlineExecutionContext.offline?
        if obj.visit_count?
          obj.update_column(:visit_count, obj.visit_count + 1)
        else
          obj.update_column(:visit_count, 1)
        end
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
      check_password
    end
    
    def indexmyplet
    end
    
    def showmyplet
    end
    
    def parent_model
      nil
    end
    
    def parent_model_list
      result = parent_model
      if !result.instance_of?(Array)
        if !result.nil?
          result = [result]
        else
          result = []
        end
      end
      result
    end
    
    def parent_model_last
      result = parent_model
      if result.instance_of?(Array)
        result = result[result.length - 1]
      end
      result
    end

    def edit_prerespond
    end
    
    def new_prerespond
    end
    
    def requires_admin
      false
    end
    
    def after_create
    end
    
    def get_default_offset
      0
    end
    
    def param_bool(name)
      result = params[name]
      if !result.blank?
        result = result.to_bool
      end
      result
    end
    
    def param_int(name, default: -1)
      result = params[name]
      if !result.blank?
        result = result.to_i
      else
        result = default
      end
      result
    end
    
    def param_string(name, default: nil)
      result = params[name]
      if result.blank?
        result = default
      end
      result
    end

    def simple_index_filters
      []
    end
    
    def enum_index_filters
      []
    end
    
    def object_to_destroy(obj)
      obj
    end
    
    def initial_checks(edit: true, require_logged_in: true)
      require_logged_in && deny_guest

      require_admin? && deny_nonadmin

      if edit && !allow_edit
        raise "Unauthorized"
      end
      
      required_capabilities.each do |capability|
        if !UserCapability.has_capability?(identity: User.current_user.current_identity, capability: capability)
          raise CanCan::AccessDenied
        end
      end
    end
    
    def required_capabilities
      []
    end
    
    def add_token(link)
      token = params[:token]
      if !token.blank?
        if link.index("?").nil?
          link = "#{link}?token=#{token}"
        else
          link = "#{link}&token=#{token}"
        end
      end
      link
    end
    
    def publicly_shareable_actions
      [:show]
    end
    
    def settings_fields
      [
        {
          type: Myp::FIELD_BOOLEAN,
          name: SETTING_ALWAYS_EXPAND_FAVORITES,
          options: {
            value: @always_expand_favorites,
            placeholder: "myplaceonline.categories.always_expand_favorites",
          }
        },
        {
          type: Myp::FIELD_BOOLEAN,
          name: SETTING_ALWAYS_EXPAND_TOP_USED,
          options: {
            value: @always_expand_top_used,
            placeholder: "myplaceonline.categories.always_expand_top_used",
          }
        },
        {
          type: Myp::FIELD_SELECT,
          name: SETTING_DEFAULT_SORT,
          options: {
            value: @setting_default_sort,
            placeholder: "myplaceonline.categories.default_sort",
            select_options: index_sorts,
            translate_select_options: false,
          }
        },
        {
          type: Myp::FIELD_SELECT,
          name: SETTING_DEFAULT_SORT_DIRECTION,
          options: {
            value: @setting_default_sort_direction,
            placeholder: "myplaceonline.categories.default_sort_direction",
            select_options: sort_options,
            translate_select_options: false,
          }
        },
      ]
    end
    
    def load_settings_params
      @always_expand_favorites = settings_boolean(name: SETTING_ALWAYS_EXPAND_FAVORITES)
      @always_expand_top_used = settings_boolean(name: SETTING_ALWAYS_EXPAND_TOP_USED)
      @setting_default_sort = settings_string(name: SETTING_DEFAULT_SORT)
      @setting_default_sort_direction = settings_string(name: SETTING_DEFAULT_SORT_DIRECTION)
    end
    
    def form_menu_items_cancel?
      true
    end
    
    def admin_sees_all?
      false
    end
    
    def nonadmin_sees_all?
      false
    end
    
    def build_new_model
    end
    
    def map_items
      self.all
    end
    
    def map_driving_time?
      false
    end
    
    def location_field
      :location
    end
    
    def map_link
      {
        title: I18n.t("myplaceonline.maps.map"),
        link: index_path + "/map",
        icon: "navigation"
      }
    end
    
    def show_map?
      false
    end
    
    def has_location?(item)
      item.respond_to?(self.location_field)
    end
    
    def get_map_location(item)
      item.send(self.location_field)
    end

    def parent_table_last_name1
      parent_model_last.table_name.singularize.downcase
    end

    def parent_table_last_name2
      parent_model_last.table_name.singularize.downcase
    end
end
