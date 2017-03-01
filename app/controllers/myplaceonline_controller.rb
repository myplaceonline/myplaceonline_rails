class MyplaceonlineController < ApplicationController
  before_action :before_all_actions
  before_action :set_obj, only: [:show, :edit, :update, :destroy]
  
  DEFAULT_SKIP_AUTHORIZATION_CHECK = [:index, :new, :create, :destroy_all]
  
  CHECK_PASSWORD_REQUIRED = 1
  CHECK_PASSWORD_OPTIONAL = 2
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK

  respond_to :html, :json

  def index
    deny_guest
    
    if sensitive
      check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    end
    
    @archived = param_bool(:archived)

    @selected_sort = params[:selected_sort]
    # Sanitize
    if !@selected_sort.blank?
      @selected_sort = @selected_sort.gsub(/[^a-zA-Z\._\(\)]/, "")
    end
    
    @selected_sort_direction = params[:selected_sort_direction]
    # Sanitize to the only two vaild values
    if @selected_sort_direction.blank?
      @selected_sort_direction = "ASC"
    elsif @selected_sort_direction.downcase != "asc" && @selected_sort_direction.downcase != "desc"
      @selected_sort_direction = "ASC"
    else
      @selected_sort_direction = @selected_sort_direction.upcase
    end
    
    if has_category && params[:myplet].nil?
      Myp.visit(current_user, category_name)
    end
    
    @offset = items_offset

    @perpage = items_per_page
    
    set_parent
    
    simple_index_filters.each do |simple_index_filter|
      instance_variable_set("@#{simple_index_filter[:name].to_s}", param_bool(simple_index_filter[:name]))
    end
    
    @count_all = all(strict: true).count
    cached_all = all
    @count = cached_all.count
    
    # Special case: If the request is for a vanilla index page (no filters), then check if there are any items that are
    # filtered. If not, then don't bother even showing the filter section. This is to avoid the most common case of 0
    # archived items
    @filtered_count = -1
    filters = index_filters
    if filters.length == 1 && filters[0][:name] == :archived && request.query_parameters.length == 0 && @count_all == @count
      @filtered_count = 0
    end
    
    @perpage = update_items_per_page(@perpage, @count)
    
    @items_next_page_link = items_next_page(@offset + @perpage)
    @items_previous_page_link = items_previous_page(@offset - @perpage)
    @items_all_link = items_all_link

    @objs = cached_all.offset(@offset).limit(@perpage).order(sorts_wrapper)
    
    # If the controller wants to show top items (`additional_items?` returns
    # true), then the only other thing we'll check is if there's more than
    # a few items
    if additional_items? && @count > 1
      @additional_items = additional_items
    end

    if favorite_items? && @count > 1
      @favorite_items = favorite_items
    end

    index_pre_respond()

    @query_params_part_all = items_query_params_part_all
    
    @myplet = params[:myplet]
    if !@myplet
      respond_with(@objs)
    else
      indexmyplet
      render action: "index", layout: "myplet"
    end
  end

  def items_offset
    result = params[:offset].nil? ? get_default_offset : params[:offset].to_i
    if result < 0
      result = 0
    end
    result
  end
  
  def items_per_page
    if params[:perpage].nil?
      result = 20
      if !current_user.items_per_page.nil?
        result = current_user.items_per_page.to_i
      end
    else
      result = params[:perpage].to_i
    end
    result
  end
  
  def update_items_per_page(perpage, count)
    if perpage <= 0
      perpage = count
    end
    perpage
  end
  
  def items_query_params_part_all
    # Save off any query parameters which might be used by AJAX callbacks to
    # index.json.erb (for example, for a full item search)
    part = Myp.query_parameters_uri_part(request, [:offset])
    result = ""
    if part.blank?
      result = "?perpage=0"
    else
      result = "?" + part + "&perpage=0"
    end
    result
  end
  
  def items_next_page(offset)
    send("#{paths_name}_path", :offset => offset)
  end
  
  def items_previous_page(offset)
    send("#{paths_name}_path", :offset => offset)
  end
  
  def items_all_link
    send("#{paths_name}_path")
  end
  
  def set_parent
    if nested
      parent_id = parent_model_last.table_name.singularize.downcase + "_id"
      @parent = Myp.find_existing_object(parent_model_last, params[parent_id], false)
    end
  end

  def show
    if sensitive
      check_password
    end
    @nested_show = params[:nested_show]
    before_show
    @myplet = params[:myplet]
    if @nested_show
      render action: "show", layout: "blank"
    elsif !@myplet
      respond_with(@obj)
    else
      showmyplet
      render action: "show", layout: "myplet"
    end
  end
  
  def new
    
    if !allow_add
      raise "Unauthorized"
    end
    
    deny_guest
    
    if !insecure
      check_password(level: MyplaceonlineController::CHECK_PASSWORD_OPTIONAL)
    end
    if sensitive
      check_password
    end
    @obj = Myp.new_model(model, params)
    set_parent
    @url = new_path
    if request.post?
      create
    else
      new_prerespond
      Rails.logger.debug{"myplaceonline_controller new: #{@obj.inspect}"}
      respond_with(@obj)
    end
  end

  def edit
    deny_guest

    check_password
    @url = obj_path(@obj)
    edit_prerespond
    respond_with(@obj)
  end
  
  def create
    deny_guest
    
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
            Rails.logger.debug{"create: @obj before assign: #{Myp.debug_print(@obj)}"}
            @obj.assign_attributes(p)
            Rails.logger.debug{"create: updated @obj: #{Myp.debug_print(@obj)}"}
          end
        rescue ActiveRecord::RecordNotFound => rnf
          raise Myp::CannotFindNestedAttribute, rnf.message + " (code needs attribute setter override?)"
        end

        if do_check_double_post
          return after_create_redirect
        end
        
        if nested
          parent_name = parent_model_last.table_name.singularize.downcase
          parent_id = parent_model_last.table_name.singularize.downcase + "_id"
          new_parent = Myp.find_existing_object(parent_model_last, params[parent_id], false)
          Rails.logger.debug{"Setting parent #{parent_id} to #{new_parent.inspect}"}
          @obj.send("#{parent_name}=", new_parent)
        end
        
        save_result = @obj.save
        
        Rails.logger.debug{"Saved #{save_result.to_s} for #{@obj.inspect}"}
        
        if save_result
          
          Rails.logger.debug{"Parent: #{@parent.inspect}, current owns? #{@obj.current_user_owns?}"}
          
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
            Myp.add_point(current_user, category_name, session)
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
    deny_guest
    
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
        .where("identity_id = ?", current_user.primary_identity.id)
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

        Rails.logger.debug{"saving updated obj: #{Myp.debug_print(@obj)}"}

        @obj.save
      ensure
        Permission.current_target = nil
      end
    end
  end
  
  def do_update_before_save
  end
  
  def after_create_redirect
    Rails.logger.debug{"after_create_redirect after_new_item: #{current_user.after_new_item}"}
    respond_to do |format|
      format.html {
        if current_user.after_new_item.nil? || current_user.after_new_item == Myp::AFTER_NEW_ITEM_SHOW_ITEM
          redirect_to_obj
        elsif current_user.after_new_item == Myp::AFTER_NEW_ITEM_SHOW_LIST
          redirect_to index_path
        elsif current_user.after_new_item == Myp::AFTER_NEW_ITEM_ANOTHER_ITEM
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
    deny_guest
    
    check_password
    ApplicationRecord.transaction do
      @obj.destroy
      if has_category
        Myp.subtract_point(current_user, category_name, session)
      end
    end

    redirect_to index_path
  end

  def destroy_all
    check_password
    deny_guest
    ApplicationRecord.transaction do
      all.each do |obj|
        authorize! :destroy, obj
        obj.destroy
        if has_category
          Myp.subtract_point(current_user, category_name, session)
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
    model.model_name.singular.to_s.downcase
  end
  
  def paths_name
    path_name.pluralize
  end
  
  def paths_form_name
    model.model_name.singular.to_s.downcase.pluralize
  end
  
  def second_path_name
    raise NotImplementedError
  end
  
  def category_name
    model.table_name
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
  
  def index_path
    send(paths_name + "_path")
  end
  
  def obj_path(obj = @obj)
    if nested
      send(path_name + "_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send(path_name + "_path", obj)
    end
  end
  
  def edit_obj_path(obj = @obj)
    if nested
      send("edit_" + path_name + "_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send("edit_" + path_name + "_path", obj)
    end
  end
  
  def archive_obj_path(obj = @obj)
    if nested
      send(path_name + "_archive_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send(path_name + "_archive_path", obj)
    end
  end
  
  def unarchive_obj_path(obj = @obj)
    if nested
      send(path_name + "_unarchive_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send(path_name + "_unarchive_path", obj)
    end
  end
  
  def favorite_obj_path(obj = @obj)
    if nested
      send(path_name + "_favorite_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send(path_name + "_favorite_path", obj)
    end
  end
  
  def unfavorite_obj_path(obj = @obj)
    if nested
      send(path_name + "_unfavorite_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send(path_name + "_unfavorite_path", obj)
    end
  end
  
  def show_path(obj)
    if nested
      send("#{path_name}_path", obj.send(parent_model.table_name.singularize.downcase), obj)
    else
      send("#{path_name}_path", obj)
    end
  end
  
  def new_path(context = nil)
    send("new_" + path_name + "_path")
  end
  
  def destroy_all_path(context = nil)
    if nested
      set_parent
      send("#{path_name.pluralize}_destroy_all_path", @parent)
    else
      send("#{path_name.pluralize}_destroy_all_path")
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
  
  def allow_add
    true
  end
  
  def show_add
    allow_add
  end
  
  def show_index_add
    allow_add
  end
  
  def show_index_footer
    true
  end
  
  def how_many_top_items
    additional_items_max_items
  end
  
  def show_created_updated
    current_user.show_timestamps
  end
  
  def form_path
    paths_name + "/form"
  end
  
  def new_title
    I18n.t("myplaceonline.general.add") + " " + I18n.t("myplaceonline.category." + category_name).singularize
  end
  
  def data_split_icon
    "check"
  end
  
  def split_link(obj)
    ""
  end
  
  def new_save_text
    I18n.t("myplaceonline.general.save") + " " + I18n.t("myplaceonline.category." + category_name).singularize
  end
  
  def index_destroy_all_link?
    false
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
  
  def share_permissions
    [Permission::ACTION_READ]
  end
  
  def nested
    false
  end
  
  def show_share
    !nested
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
    [
      [I18n.t("myplaceonline.general.visit_count"), "#{model.table_name}.visit_count"],
      [I18n.t("myplaceonline.general.created_at"), "#{model.table_name}.created_at"],
      [I18n.t("myplaceonline.general.updated_at"), "#{model.table_name}.updated_at"]
    ]
  end

  def sorts_helper
    if !@selected_sort.blank?
      # Sanitized above
      ["#{@selected_sort} #{@selected_sort_direction} nulls last"]
    else
      if block_given?
        yield
      else
        ["updated_at #{@selected_sort_direction}"]
      end
    end
  end

  def footer_items_index
    result = []
    if self.show_index_add
      result << {
        title: I18n.t("myplaceonline.general.add") + " " + t("myplaceonline.category." + self.category_name).singularize,
        link: self.new_path,
        icon: "plus"
      }
    end
    if self.index_destroy_all_link?
      result << {
        title: I18n.t("myplaceonline.general.delete_all"),
        link: self.destroy_all_path,
        icon: "delete"
      }
    end
    result
  end
  
  def footer_items_show
    result = []
    result << {
      title: I18n.t('myplaceonline.general.edit'),
      link: self.edit_obj_path,
      icon: "edit"
    }
    if @obj.respond_to?("is_archived?") && (!nested || !parent_model.is_a?(Array))
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
    result << {
      title: I18n.t("myplaceonline.general.back_to_list"),
      link: self.back_to_all_path,
      icon: "back"
    }
    if self.show_add
      result << {
        title: self.add_another_name,
        link: self.new_path(@obj),
        icon: "plus"
      }
    end
    if self.show_share
      result << {
        title: I18n.t('myplaceonline.permission_shares.share'),
        link: permissions_share_path + "?" + Permission.permission_params(self.category_name, @obj.id, self.share_permissions).to_query,
        icon: "action"
      }
    end
    if @obj.respond_to?("rating") && (!nested || !parent_model.is_a?(Array))
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
    result << {
      title: I18n.t('myplaceonline.general.delete'),
      link: self.obj_path,
      icon: "delete",
      method: :delete,
      data: { confirm: 'Are you sure?' }
    }
    result
  end
  
  def archive(notice: I18n.t("myplaceonline.general.archived"))
    set_obj
    # Some models have after_saves that do things like recalculate
    # calendar items, but we can just surgically update this field
    # and skip that
    @obj.update_column(:archived, Time.now)
    redirect_to index_path,
      :flash => { :notice => notice }
  end
  
  def unarchive(notice: I18n.t("myplaceonline.general.unarchived"))
    set_obj
    @obj.update_column(:archived, nil)
    redirect_to index_path,
      :flash => { :notice => notice }
  end
  
  def favorite(notice: I18n.t("myplaceonline.general.favorited"))
    set_obj
    @obj.update_column(:rating, Myp::MAX_RATING)
    redirect_to obj_path,
      :flash => { :notice => notice }
  end
  
  def unfavorite(notice: I18n.t("myplaceonline.general.unfavorited"))
    set_obj
    @obj.update_column(:rating, nil)
    redirect_to obj_path,
      :flash => { :notice => notice }
  end
  
  def index_filters
    result = [
      {
        :name => :archived,
        :display => "myplaceonline.general.archived"
      }
    ]
    simple_index_filters.each do |simple_index_filter|
      result << {
        :name => simple_index_filter[:name],
        :display => "myplaceonline.#{category_name}.#{simple_index_filter[:name].to_s}"
      }
    end
    result
  end
  
  protected
  
    def deny_guest
      if current_user.guest?
        Rails.logger.debug{"Denying guest access"}
        raise CanCan::AccessDenied
      end
    end
  
    def obj_params
      raise NotImplementedError
    end
    
    def sorts
      raise NotImplementedError
    end
    
    def sorts_wrapper
      sorts_helper {sorts}
    end
    
    def sensitive
      false
    end
    
    def insecure
      false
    end
    
    def before_all_actions
      if requires_admin && !current_user.admin?
        raise CanCan::AccessDenied
      end
    end
    
    def all_additional_sql(strict)
      result = nil
      if !strict
        if @archived.blank? || !@archived
          result = Myp.appendstr(result, "#{model.table_name}.archived is null", nil, " and (", ")")
        end
        simple_index_filters.each do |simple_index_filter|
          if !simple_index_filter[:column]
            colname = simple_index_filter[:name].to_s
          else
            colname = simple_index_filter[:column].to_s
          end
          
          if instance_variable_get("@#{simple_index_filter[:name].to_s}")
            if !simple_index_filter[:inverted]
              sql = "#{model.table_name}.#{colname} = true"
            else
              sql = "#{model.table_name}.#{colname} is null or #{model.table_name}.#{colname} = false"
            end
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
        current_user.id,
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
        parent_id = parent_model_last.table_name.singularize.downcase + "_id"
        additional += " AND #{model.table_name}.#{parent_id} = #{ActionController::Base.helpers.sanitize(params[parent_id.to_sym])}"
      end
      Rails.logger.debug{"all query strict: #{strict}, additional: #{additional}"}
      model.includes(all_includes).joins(all_joins).where(
        "(#{model.table_name}.identity_id = ? #{initial_or}) #{additional}",
        current_user.primary_identity.id
      )
    end
    
    def additional_items(strict: false)
      additional = all_additional_sql(strict)
      if additional.nil?
        additional = ""
      end
      model.includes(all_includes).joins(all_joins).where(
        model.table_name + ".identity_id = ? and " + model.table_name + ".visit_count >= ? " + additional,
        current_user.primary_identity,
        additional_items_min_visit_count
      ).limit(additional_items_max_items).order(additional_items_sort)
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
        model.table_name + ".identity_id = ? and " + model.table_name + ".rating = ? " + additional,
        current_user.primary_identity,
        Myp::MAX_RATING
      ).limit(favorite_items_max_items).order(favorite_items_sort)
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
          parent_id = parent_model_last.table_name.singularize.downcase + "_id"
          Rails.logger.debug{"MyplaceonlineController.set_obj parent_id: #{parent_id}, param: #{p[parent_id]}"}
          if !p[parent_id].nil?
            @parent = Myp.find_existing_object(parent_model_last, p[parent_id], false)
            Rails.logger.debug{"MyplaceonlineController.set_obj parent: #{@parent.inspect}"}
            @obj = model.where("id = ? and #{parent_id} = ?", p[:id].to_i, p[parent_id.to_sym].to_i).take!
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
        raise Myp::SuddenRedirectError.new(index_path)
      end
      
      authorize! action.to_sym, @obj
      
      # If this succeeds, then set the identity context for nested authorization checks
      Ability.context_identity = @obj.identity
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
      if obj.respond_to?("visit_count")
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
end
