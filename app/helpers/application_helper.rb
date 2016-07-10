require 'htmlentities'

module ApplicationHelper
  def flashes!(obj = nil)
    if flash.empty? && (obj.nil? || (!obj.nil? && obj.errors.empty?))
      return ""
    end
    
    messages = flash.map { |name, msg| content_tag(:li, msg) }.join
    if !obj.nil? && obj.errors.any?
      messages += obj.errors.full_messages.each.map{ |msg| content_tag(:li, msg) }.join
    end

    html = <<-HTML
    <div class="errors">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  def page_heading(obj, controller)
    result = I18n.t("myplaceonline.category.#{controller.category_name}").singularize
    obj_display = controller.display_obj(obj)
    if !obj_display.nil?
      result += ": "
      result += obj_display
    end
    result
  end
  
  def is_blank(value, strip = true)
    if strip && value.is_a?(String) && !value.nil?
      value = value.strip
    end
    value.nil? ||
      (value.is_a?(String) &&
        (value.length == 0 || value == "&nbsp;"))
  end
  
  def attribute_table_start
    %{
  <table data-role="table" data-mode="reflow" class="ui-responsive tablestripes normalwidth firstcolumnbold noheadertable">
    <thead>
      <tr>
        <th></th>
        <th></th>
        <th></th>
      </tr>
    <tbody>
    }.html_safe
  end
  
  def attribute_table_end
    %{
    </tbody>
  </table>
    }.html_safe
  end
  
  def attribute_table_row_highlight(name, value, clipboard_text = value, valueclass = nil)
    if valueclass.nil?
      valueclass = "bghighlight"
    else
      valueclass += " bghighlight"
    end
    attribute_table_row(name, value, clipboard_text, valueclass)
  end
  
  def attribute_table_row_clipboard(clipboard_text)
    if !is_blank(clipboard_text.to_s)
      options = Hash.new
      options[:href] = "#"
      options[:class] = "ui-btn ui-icon-action ui-btn-icon-notext nomargin clipboardable"
      options[:title] = t("myplaceonline.general.clipboard")
      options["data-clipboard-text"] = HTMLEntities.new.encode(clipboard_text_str(clipboard_text))
      
      content_tag(
        :a,
        t("myplaceonline.general.clipboard"),
        options
      )
    else
      "&nbsp;"
    end
  end
  
  def attribute_table_row(name, value, clipboard_text = value, valueclass = nil)
    if is_blank(value)
      return nil
    end
    valueclass ||= ""
    
    lastcolumn = attribute_table_row_clipboard(clipboard_text)
    
    attribute_table_row_content(
      name,
      valueclass,
      value,
      lastcolumn
    )
  end
  
  def clipboard_text_str(clipboard_text)
    result = ""
    if !clipboard_text.blank?
      result = clipboard_text.to_s
      if !User.current_user.nil? && User.current_user.clipboard_transform_numbers
        # Haven't been able to find out where, but in some cases, trying to
        # use the firefox clipboard SDK to copy values that look
        # like credit cards to the clipboard are actually suppressed.
        if (result.length == 15 && result.gsub(/[^0-9]+/, "").length == 15) || (result.length == 16 && result.gsub(/[^0-9]+/, "").length == 16)
          result += " "
        end
      end
    end
    result
  end
  
  def attribute_table_row_content(name, contentclass, content, lastcolumn = "&nbsp;")
    html = <<-HTML
    <tr>
      <td>#{name}</td>
      <td class="#{contentclass}">#{content}</td>
      <td style="padding: 0.2em; vertical-align: top;">#{lastcolumn}</td>
    </tr>
    HTML
    
    html.html_safe
  end
  
  def table_row_heading(name)
    html = <<-HTML
    <tr>
      <td colspan="3" style="font-weight: bold; text-decoration: underline;">#{name}</td>
    </tr>
    HTML
    
    html.html_safe
  end
  
  def attribute_table_row_span(content)
    html = <<-HTML
    <tr>
      <td colspan="3">#{content}</td>
    </tr>
    HTML
    
    html.html_safe
  end
  
  def file_audio(identity_file)
    html = <<-HTML
    <audio src="#{file_view_name_path(identity_file, identity_file.urlname, token: params[:token])}" preload="none" controls>
      <p>#{I18n.t("myplaceonline.html5.noaudio")}</p>
    </audio>
    #{ url_or_blank(file_download_path(identity_file, token: params[:token]), t("myplaceonline.files.download"), nil, "ui-btn ui-btn-inline", true) }
    HTML
  end
  
  def attribute_table_row_file_audio(name, identity_file)
    if !identity_file.nil? && !identity_file.file_content_type.nil? && identity_file.file_content_type.start_with?("audio")
      html = file_audio(identity_file)
      attribute_table_row_content(
        name,
        nil,
        html.html_safe
      )
    else
      nil
    end
  end
  
  def attribute_table_row_file(name, identity_file)
    if !identity_file.nil?
      attribute_table_row_content(
        identity_file.display,
        nil,
        url_or_blank(
          file_download_path(identity_file),
          t("myplaceonline.files.download"),
          nil,
          nil,
          true
        )
      )
    else
      nil
    end
  end
  
  def file_image?(identity_file)
    !identity_file.nil? && !identity_file.file_content_type.nil? && (identity_file.file_content_type.start_with?("image"))
  end
  
  def has_image(identity_file)
    !identity_file.nil? && !identity_file.file.nil? && !identity_file.file_content_type.nil? && (identity_file.file_content_type.start_with?("image"))
  end
  
  def has_thumbnail(identity_file)
    !identity_file.nil? && !identity_file.thumbnail_skip && !identity_file.thumbnail_contents.nil?
  end
  
  def image_content(identity_file, link_to_original = true, useParams: true)
    if has_image(identity_file)
      identity_file.ensure_thumbnail
      
      # Include a unique query parameter all the time because the thumbnail
      # may have been updated
      if has_thumbnail(identity_file)
        if useParams
          content = image_tag(file_thumbnail_name_path(identity_file, identity_file.urlname, :h => identity_file.thumbnail_hash, token: params[:token]), alt: identity_file.display, title: identity_file.display)
        else
          content = image_tag(file_thumbnail_name_path(identity_file, identity_file.urlname, :h => identity_file.thumbnail_hash), alt: identity_file.display, title: identity_file.display)
        end
      else
        if useParams
          content = image_tag(file_view_name_path(identity_file, identity_file.urlname, token: params[:token]), alt: identity_file.display, title: identity_file.display)
        else
          content = image_tag(file_view_name_path(identity_file, identity_file.urlname), alt: identity_file.display, title: identity_file.display)
        end
      end
      if link_to_original
        if useParams
          url_or_blank(
            file_view_name_path(identity_file, identity_file.urlname, token: params[:token]),
            content,
            nil,
            "externallink",
            true
          )
        else
          url_or_blank(
            file_view_name_path(identity_file, identity_file.urlname),
            content,
            nil,
            "externallink",
            true
          )
        end
      else
        content
      end
    else
      nil
    end
  end
  
  def attribute_table_row_image(name, identity_file, link_to_original = true)
    content = image_content(identity_file, link_to_original)
    if !content.nil?
      content += "<p>#{url_or_blank(file_path(identity_file, token: params[:token]), identity_file.file_file_name, nil, "", true)} | #{url_or_blank(file_download_name_path(identity_file, identity_file.urlname, token: params[:token]), t("myplaceonline.files.download"), nil, "", true)}</p>".html_safe
      if !identity_file.notes.blank?
        content += Myp.markdown_to_html(identity_file.notes).html_safe
      end
      attribute_table_row_content(
        name,
        nil,
        content
      )
    else
      content = "<p>#{url_or_blank(file_path(identity_file, token: params[:token]), identity_file.file_file_name, nil, "", true)} | #{url_or_blank(file_download_name_path(identity_file, identity_file.urlname, token: params[:token]), t("myplaceonline.files.download"), nil, "", true)}</p>".html_safe
      if !identity_file.notes.blank?
        content += Myp.markdown_to_html(identity_file.notes).html_safe
      end
      attribute_table_row_content(
        name,
        nil,
        content
      )
    end
  end
  
  def attribute_table_row_url(name, url, may_be_nonurl = false, url_text = nil, clipboard = nil, linkclasses = nil, external = false, external_target_blank = false)
    if may_be_nonurl && !url.blank? && !url.start_with?("/") && !url.start_with?("http:")
      # Probably not a URL, just display raw text
      attribute_table_row(name, url)
    else
      attribute_table_row(name, url_or_blank(url, url_text, clipboard, linkclasses, external, external_target_blank), url, nil)
    end
  end
  
  def attribute_table_row_email(name, email)
    if !email.blank? && email.include?("@")
      attribute_table_row(name, url_or_blank("mailto:" + email, email), email)
    else
      attribute_table_row(name, email)
    end
  end
  
  def attribute_table_row_markdown(name, markdown)
    attribute_table_row(name, Myp.markdown_to_html(markdown), markdown, "markdowncell")
  end
  
  def markdown_content(markdown)
    result = Myp.markdown_to_html(markdown)
    if !result.nil?
      result.html_safe
    else
      nil
    end
  end
  
  def attribute_table_row_boolean(name, val, hide_if_false: true)
    if hide_if_false && !val
      nil
    else
      attribute_table_row(name, val ? t("myplaceonline.general.yes") : t("myplaceonline.general.no"))
    end
  end

  def attribute_table_row_reference(name, pathfunc, ref, controllerName: nil)
    if !ref.nil?
      url = send(pathfunc, ref)
      result = attribute_table_row(name, url_or_blank(url, ref.display), url)
      if Thread.current[:show_nest_level].nil? && Thread.current[:nest_count] < 10
        begin
          Thread.current[:show_nest_level] = 1
          Thread.current[:nest_count] = Thread.current[:nest_count] + 1
          render_result = renderActionInOtherController(
              Object.const_get(controllerName.nil? ? ref.class.name.pluralize + "Controller" : controllerName),
              :show,
              {
                id: ref.id,
                nested_show: true
              }
            ).html_safe
          result += render_result
        ensure
          Thread.current[:show_nest_level] = nil
        end
      end
      result
    else
      nil
    end
  end
  
  def attribute_table_row_date(name, d)
    attribute_table_row(name, d.nil? ? nil : Myp.display_date(d, current_user))
  end
  
  def attribute_table_row_date_diff(name, date1, date2)
    if !date1.nil? && !date2.nil?
      attribute_table_row(name, Myp.time_difference_in_general_human(TimeDifference.between(date1, date2).in_general))
    else
      nil
    end
  end
  
  def attribute_table_row_datetime(name, d)
    attribute_table_row(name, d.nil? ? nil : Myp.display_datetime(d, current_user))
  end
  
  def attribute_table_row_select(name, val, select_values)
    attribute_table_row(name, Myp.get_select_name(val, select_values))
  end
  
  def attribute_table_row_weight(name, val, weight_type)
    if !val.nil?
      attribute_table_row(name, ActionController::Base.helpers.pluralize(val, Myp.get_select_name(weight_type, Myp::WEIGHTS).singularize))
    else
      nil
    end
  end
  
  def attribute_table_row_liquid_concentration(name, val, concentration_type, pluralize = true)
    if !val.nil?
      if concentration_type.nil?
        attribute_table_row(
          name,
          val.to_s
        )
      else
        if pluralize
          attribute_table_row(
            name,
            ActionController::Base.helpers.pluralize(val, Myp.get_select_name(concentration_type, Myp::LIQUID_CONCENTRATIONS).singularize)
          )
        else
          attribute_table_row(
            name,
            val.to_s + " " + Myp.get_select_name(concentration_type, Myp::LIQUID_CONCENTRATIONS)
          )
        end
      end
    else
      nil
    end
  end
  
  def numberth(num)
    if num == 1
      "st"
    elsif num == 2
      "nd"
    elsif num == 3
      "rd"
    elsif num >= 4
      "th"
    end
  end
  
  def attribute_table_row_period(name, val, period_type, pluralize = true)
    if !val.nil?
      if period_type.nil?
        attribute_table_row(
          name,
          val.to_s
        )
      else
        if period_type >= 3 && period_type <= 9
          attribute_table_row(
            name,
            val.to_s + numberth(val) + " " + Myp.get_select_name(period_type, Myp::PERIOD_TYPES).gsub("Nth", "")
          )
        else
          attribute_table_row(
            name,
            Myp.get_select_name(period_type, Myp::PERIOD_TYPES).gsub(" X ", " " + val.to_s + " ")
          )
        end
      end
    else
      nil
    end
  end
  
  def attribute_table_row_duration(name, start_time, end_time = DateTime.now)
    if !start_time.nil? && !end_time.nil?
      if end_time > start_time
        attribute_table_row(
          name,
          Myp.time_difference_in_general_human_detailed(TimeDifference.between(start_time, end_time).in_general)
        )
      else
        attribute_table_row(
          name,
          Myp.time_difference_in_general_human_detailed(TimeDifference.between(end_time, start_time).in_general)
        )
      end
    else
      nil
    end
  end
  
  def attribute_table_row_food_weight(name, val, weight_type)
    if !val.nil?
      attribute_table_row(name, ActionController::Base.helpers.pluralize(val, Myp.get_select_name(weight_type, Myp::FOOD_WEIGHTS).singularize))
    else
      nil
    end
  end
  
  def attribute_table_row_currency(name, val)
    if !val.nil?
      attribute_table_row(name, Myp.number_to_currency(val))
    else
      nil
    end
  end
  
  def attribute_table_row_dimensions(name, val, dimensions_type)
    if !val.blank? && !dimensions_type.nil?
      if dimensions_type == 0
        original_val = val
        human_readable = ""
        extra = ""
        is_split = false
        if val >= 12
          feet = (val/12).floor
          human_readable = feet.to_s + "'"
          val = val % 12
          extra = ActionController::Base.helpers.pluralize(feet, "foot")
          is_split = true
        end
        if val > 0
          if human_readable.length > 0
            human_readable += " "
          end
          human_readable += Myp.truncate_zeros(val.to_s) + "\""
          if extra.length > 0
            extra += ", "
          end
          extra += Myp.truncate_zeros(ActionController::Base.helpers.pluralize(val, "inch"))
        end
        if is_split
          if extra.length > 0
            extra += "; "
          end
          extra += "total: " + Myp.truncate_zeros(ActionController::Base.helpers.pluralize(original_val, "inch"))
        end
        if extra.length > 0
          human_readable += " (" + extra + ")"
        end
        attribute_table_row(name, human_readable)
      else
        raise "TODO"
      end
    else
      nil
    end
  end
  
  def url_or_blank(url, inner_content = nil, clipboard = nil, linkclasses = nil, external = false, external_target_blank = false)
    if !url.to_s.empty?
      if inner_content.nil? || inner_content.to_s.empty?
        inner_content = url
      end
      
      options = Hash.new
      options[:href] = url
      options[:class] = ""
      
      # If it's probably external
      if external || (!url.start_with?("/") || url.start_with?("//"))
        if external_target_blank
          options[:target] = "_blank"
        end
        options["data-ajax"] = "false"
      end
      if !clipboard.nil?
        options[:class] += " clipboardable"
        options["data-clipboard-text"] = HTMLEntities.new.encode(clipboard_text_str(clipboard))
        options["data-clipboard-clickthrough"] = "yes"
      end
      if !linkclasses.blank?
        options[:class] += " " + linkclasses
      end
      
      content_tag(
        :a,
        inner_content,
        options
      )
    else
      "&nbsp;"
    end
  end
  
  # We only want to show the label if `value` is blank.
  def myp_label_classes(value)
    is_blank(value, false) ? "ui-hidden-accessible" : "form_field_label"
  end
  
  def myp_field_classes(autofocus, input_classes)
    result = autofocus ? "autofocus" : ""
    if !input_classes.nil? && input_classes.length > 0
      if result.length > 0
        result += " "
      end
      result += input_classes
    end
    result
  end
  
  def myp_hidden_field(form, name, value = nil)
    form.hidden_field(name, value: value)
  end
                       
  def myp_hidden_field_tag(name, value = nil)
    hidden_field_tag(name, value)
  end

  # remote_autocomplete_all: if true, show all items on focus; otherwise, show only items that match what's typed
  def myp_text_field(form, name, placeholder, value, autofocus = false, input_classes = nil, autocomplete = true, options = {}, remote_autocomplete_model: nil, remote_autocomplete_all: false)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    baseoptions = {
      placeholder: placeholder,
      class: myp_field_classes(autofocus, input_classes),
      value: value
    }
    if !autocomplete
      baseoptions[:autocomplete] = "off"
    end
    field = form.text_field(name, baseoptions.merge(options))
    result = content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      field
    ).html_safe
    
    if !remote_autocomplete_model.nil?
      id = extract_id(result)
      autocomplete_id = id + "_remote_autocomplete"
      remote_autocomplete_all_script = ""
      if remote_autocomplete_all
        remote_autocomplete_all_script = <<-eos
          $("##{id}").on("focus", function() {
            myplaceonline.listviewSearch($("##{autocomplete_id}"), "/api/distinct_values.json?table_name=#{remote_autocomplete_model}&column_name=#{name}", null);
            $("##{autocomplete_id} li").removeClass("ui-screen-hidden");
          });
          $("##{id}").on("blur", function() {
            setTimeout(function() {
              $("##{autocomplete_id} li").addClass("ui-screen-hidden");
            }, 500);
          });
        eos
      end
      additional = <<-eos
        <ul data-role="listview" data-inset="true" data-filter="true" data-filter-reveal="#{remote_autocomplete_all ? false : true}" data-input="##{id}" id="#{autocomplete_id}">
        </ul>
        <script type="text/javascript">
          myplaceonline.onPageLoad(function() {
            $("##{autocomplete_id}").on("click", "li", function() {
              $("##{id}").val($(this).text());
              $("##{autocomplete_id} li").addClass("ui-screen-hidden");
            });
            myplaceonline.hookListviewSearch($("##{autocomplete_id}"), "/api/distinct_values.json?table_name=#{remote_autocomplete_model}&column_name=#{name}");
            
            // When hooking up our input to the listview autocomplete with data-input, enter is squashed
            $("##{id}").on('keydown', function(e) {
              var code = (e.keyCode ? e.keyCode : e.which);
              if (code == 13) {
                $(this.form).find(":submit").first().click();
              }
            });
            
            #{remote_autocomplete_all_script}
          });
        </script>
      eos
      result += additional.html_safe
    end
    
    result
  end
  
  def myp_number_field(form, name, placeholder, value, autofocus = false, input_classes = nil, step = nil, options = {})
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    baseoptions = {
      placeholder: placeholder,
      class: myp_field_classes(autofocus, input_classes),
      value: value,
      step: step
    }
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.send(Myp.use_html5_inputs ? "number_field" : "text_field", name, baseoptions.merge(options))
    ).html_safe
  end
  
  def myp_decimal_field(form, name, placeholder, value, autofocus = false, input_classes = nil, step = Myp::DEFAULT_DECIMAL_STEP, options = {})
    myp_number_field(form, name, placeholder, value, autofocus, input_classes, step, options)
  end
  
  def myp_integer_field(form, name, placeholder, value, autofocus = false, input_classes = nil)
    myp_number_field(form, name, placeholder, value, autofocus, input_classes)
  end
  
  def myp_text_field_tag(name, placeholder, value, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      label_tag(name, placeholder, class: myp_label_classes(value)) +
      text_field_tag(name, value, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes))
    ).html_safe
  end
  
  def myp_timespan_field(form, name, placeholder, value, autofocus = false, defaultValueSeconds = nil, input_classes = nil)
    if defaultValueSeconds.nil?
      defaultValueSeconds = 0
    end
    result = myp_text_field(form, name, placeholder, value, autofocus, input_classes)
    id = extract_id(result)
    script = <<-eos
      <script type="text/javascript">
        $("##{ id }").datebox({
          mode: "durationbox",
          useFocus: true,
          useClearButton: true,
          useModal: true,
          useButton: false,
          defaultValue: #{ defaultValueSeconds }
        });
      </script>
    eos
    result + script.html_safe
  end
  
  def myp_datetime_field(form, name, placeholder, value, autofocus = false, input_classes = nil, override_datebox_type = nil)
    myp_date_field(form, name, placeholder, value, autofocus, input_classes, "datetime", Myplaceonline::DEFAULT_TIME_FORMAT)
  end
  
  def myp_date_field(form, name, placeholder, value, autofocus = false, input_classes = nil, override_datebox_type = nil, date_format = Myplaceonline::DEFAULT_DATE_FORMAT)
    # http://dev.jtsage.com/jQM-DateBox/api/
    # http://dev.jtsage.com/jQM-DateBox/doc/3-0-first-datebox/
    # Options should match app/assets/javascripts/myplaceonline_final.js formAddItem
    # https://github.com/jtsage/jquery-mobile-datebox/issues/363
    # https://github.com/jtsage/jquery-mobile-datebox/issues/295
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    
    hidden_time = nil
    random_name = ""
    close_callback = "false"
    element_type = "text_field"
    #element_type = "date_field"
    
    # datebox or calbox
    datebox_type = "calbox"
    if !override_datebox_type.nil?
      datebox_type = override_datebox_type
      if override_datebox_type == "datetime"
        random_name = SecureRandom.hex(10)
        hidden_time = hidden_field_tag(
          random_name,
          value.nil? ? value : value.to_s(:timebox),
          "data-role" => "datebox",
          "data-datebox-mode" => "timebox",
          "data-datebox-override-date-format" => Myplaceonline::JQM_DATEBOX_TIMEBOX_FORMAT,
          "data-datebox-use-focus" => "true",
          "data-datebox-use-modal" => "false",
          "data-datebox-use-button" => "false",
          "data-datebox-popup-position" => "window",
          "data-datebox-close-callback" => "dateboxTimeboxClosed"
        )
        datebox_type = "calbox"
        close_callback = "dateboxCalendarClosed"
        element_type = "text_field"
        #element_type = "datetime_local_field"
      end
    end
    if !Myp.use_html5_date_inputs
      element_type = "text_field"
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.send(element_type,
        name,
        placeholder: placeholder,
        class: myp_field_classes(autofocus, input_classes),
        value: value,
        "data-role" => "datebox",
        "data-datebox-mode" => datebox_type,
        "data-datebox-override-date-format" => date_format,
        "data-datebox-use-focus" => "true",
        "data-datebox-use-clear-button" => "true",
        "data-datebox-use-modal" => "false",
        "data-datebox-cal-use-pickers" => "true",
        "data-datebox-cal-year-pick-min" => "-100",
        "data-datebox-cal-year-pick-max" => "10",
        "data-datebox-cal-no-header" => "true",
        "data-datebox-close-callback" => close_callback,
        "data-datetime-id" => random_name
      ) + hidden_time
    ).html_safe
  end

  def myp_file_field(form, name, placeholder, value, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if value.size.nil?
      value = nil
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: "form_field_label") +
      form.file_field(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value)
    ).html_safe
  end
  
  def myp_text_area(form, name, placeholder, value, autofocus = false, input_classes = nil)
    # No need to set 'rows' or height because of autogrow:
    # https://github.com/jquery/jquery-mobile/blob/master/js/widgets/forms/autogrow.js
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.text_area(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value)
    ).html_safe
  end

  def myp_text_area_tag(name, placeholder, value, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      label_tag(name, placeholder, class: myp_label_classes(value)) +
      text_area_tag(name, value, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes))
    ).html_safe
  end

  def myp_text_area_markdown(form, name, placeholder, value, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    result = render(partial: 'myplaceonline/rte', locals: {
      f: form,
      markdown_data: value,
      hidden_field_name: name
    })
    form.label(name, placeholder, class: "form_field_label") + result + "<br />".html_safe
    #myp_text_area(form, name, I18n.t(placeholder) + " (" + I18n.t("myplaceonline.general.supports_markdown") + ")", value, autofocus, input_classes)
  end

  def myp_check_box(form, name, placeholder, autofocus = false, input_classes = nil, title: nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.check_box(name, class: myp_field_classes(autofocus, input_classes)) +
      form.label(name, placeholder, title: title)
    ).html_safe
  end
  
  def myp_check_box_tag(name, placeholder, checked, autofocus = false, input_classes = nil, onclick = "")
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      check_box_tag(name, true, checked, class: myp_field_classes(autofocus, input_classes), :onclick=> onclick) +
      label_tag(name, placeholder)
    ).html_safe
  end
  
  def default_region
    "US"
  end

  def myp_region_field(form, name, placeholder, value, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if input_classes.nil?
      input_classes = ""
    else
      input_classes += " "
    end
    input_classes += "region"
    if value.blank?
      value = default_region
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: "ui-hidden-accessible") +
      form.select(name, region_options_for_select(Carmen::Country.all, value, priority: [default_region]), { include_blank: placeholder }, { :class => myp_field_classes(autofocus, input_classes) })
    ).html_safe
  end
  
  def myp_subregion_field(form, name, placeholder, regionvalue, subregionvalue)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if regionvalue.blank?
      regionvalue = default_region
    end
    render(partial: 'myplaceonline/subregionselect', locals: { f: form, regionstr: regionvalue, subregion: subregionvalue })
  end

  def myp_subregion_select_field(form, name, placeholder, region, subregionvalue, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if region.blank?
      region = Carmen::Country.coded(default_region)
    end
    options = Carmen::Country.coded(region.code).subregions.map { |r| [r.name, r.code] }
    options.sort!{|a, b| a.first.to_s <=> b.first.to_s}
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(subregionvalue)) +
      form.select(name, options_for_select(options, subregionvalue), class: myp_field_classes(autofocus, input_classes), include_blank: placeholder)
    ).html_safe
  end
  
  # http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html
  def myp_select(form, name, placeholder, selectoptions, selectvalue, autofocus = false, input_classes = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(selectvalue)) +
      form.select(name, options_for_select(selectoptions, selectvalue), class: myp_field_classes(autofocus, input_classes), prompt: placeholder, include_blank: !selectvalue.nil?)
    ).html_safe
  end
  
  def myp_select_tag(name, placeholder, selectoptions, selectvalue, autofocus = false, input_classes = nil, inline = false, onchange = nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    options = Hash.new
    options[:class] = myp_field_classes(autofocus, input_classes)
    options[:prompt] = placeholder
    options[:include_blank] = !selectvalue.nil?
    if inline
      options["data-inline"] = "true"
    end
    if !onchange.nil?
      options["onchange"] = onchange
    end
    content_tag(
      :p,
      label_tag(name, placeholder, class: myp_label_classes(selectvalue)) +
      select_tag(name, options_for_select(selectoptions, selectvalue), options)
    ).html_safe
  end
  
  def single_quote_escape(str)
    str.sub("'", "")
  end
  
  def find_category_by_url
    result = nil
    url = request.path
    if url.length > 1 and url[0] == "/"
      url = url[1..-1]
      i = url.index('/')
      if !i.nil?
        url = url[0..i-1]
      end
      i = url.index('?')
      if !i.nil?
        url = url[0..i-1]
      end
      if url.length > 0
        result = Myp.categories(User.current_user)[url.to_sym]
      end
    end
    result
  end
  
  def header_icon
    category = find_category_by_url
    if category.nil? || category.icon.blank?
      "myplaceonlinelogo.gif"
    else
      category.icon
    end
  end
  
  def header_link
    category = find_category_by_url
    if category.nil? || category.icon.blank?
      "/"
    else
      "/" + category.link
    end
  end
  
  def header_title
    category = find_category_by_url
    if category.nil? || category.icon.blank?
      t("myplaceonline.siteTitle")
    else
      category.human_title
    end
  end
  
  # http://stackoverflow.com/a/7085969
  def renderActionInOtherController(controller, action, params)
    c = controller.new
    c.params = params
    # TODO before_actions are not called (process_action is protected and
    # calling it through a public wrapper doesn't work)
    c.dispatch(action, request)
    if c.response.response_code == 302
      # Assume password required redirect
      raise Myp::DecryptionKeyUnavailableError
    end
    c.response.body
  end
  
  def extract_id(html)
    html.match("id=\"([^\"]+)\"")[1]
  end
  
  def bytes_number(num)
    if num >= 1073741824
      (num / 1073741824).to_s + " GB"
    elsif num >= 1048576
      (num / 1048576).to_s + " MB"
    elsif num >= 1024
      (num / 1024).to_s + " KB"
    else
      (num).to_s
    end
  end
  
  def identity_files_include_pics?(identity_files)
    identity_files.any?{|identity_file| file_image?(identity_file) }
  end
end
