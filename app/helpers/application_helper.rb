module ApplicationHelper
  def flashes!
    return "" if flash.empty?
    
    messages = flash.map { |name, msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class="errors">
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
  
  def is_blank(value, strip = true)
    if strip && value.is_a?(String) && !value.nil?
      value = value.strip
    end
    value.nil? ||
      (value.is_a?(String) &&
        (value.length == 0 || value == "&nbsp;"))
  end
  
  def attribute_table_row_highlight(name, value, clipboard_text = value, valueclass = nil)
    if valueclass.nil?
      valueclass = "bghighlight"
    else
      valueclass += " bghighlight"
    end
    attribute_table_row(name, value, clipboard_text, valueclass)
  end
  
  def attribute_table_row(name, value, clipboard_text = value, valueclass = nil)
    if is_blank(value)
      return nil
    end
    valueclass ||= ""
    attribute_table_row_content(
      name,
      valueclass,
      value,
      !is_blank(clipboard_text.to_s) ?
        content_tag(
          :a,
          t("myplaceonline.general.clipboard"),
          href: "#",
          class: "ui-btn ui-icon-action ui-btn-icon-notext nomargin clipboardable externallink",
          title: t("myplaceonline.general.clipboard"),
          data: { "clipboard-text" => html_escape(clipboard_text_str(clipboard_text)) }
        )
        : "&nbsp;"
    )
  end
  
  def clipboard_text_str(clipboard_text)
    result = ""
    if !clipboard_text.blank?
      result = clipboard_text.to_s
      # Haven't been able to find out where, but in some cases, trying to
      # use the firefox clipboard SDK to copy to copy values that look
      # like credit cards to the clipboard are actually suppressed.
      if (result.length == 15 && result.gsub(/[^0-9]+/, "").length == 15) || (result.length == 16 && result.gsub(/[^0-9]+/, "").length == 16)
        result += " "
      end
    end
    result
  end
  
  def attribute_table_row_content(name, contentclass, content, lastcolumn = nil)
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
  
  def attribute_table_row_image(name, identity_file, link_to_original = true)
    if !identity_file.nil? && !identity_file.file_content_type.nil? && (identity_file.file_content_type.start_with?("image"))
      if identity_file.thumbnail_contents.nil?
        image = Magick::Image::from_blob(identity_file.file.file_contents)
        image = image.first
        max_width = 400
        if image.columns > max_width
          image.resize_to_fit!(max_width)
          blob = image.to_blob
          identity_file.thumbnail_contents = blob
          identity_file.thumbnail_bytes = blob.length
          identity_file.save!
        end
      end
      image_content = image_tag(file_thumbnail_path(identity_file))
      if link_to_original
        attribute_table_row_content(
          name,
          nil,
          url_or_blank(
            file_view_path(identity_file),
            image_content, nil, nil, true
          )
        )
      else
        attribute_table_row_content(
          name,
          nil,
          image_content
        )
      end
    else
      nil
    end
  end
  
  def attribute_table_row_url(name, url, may_be_nonurl = false, url_text = nil, clipboard = nil, linkclasses = nil, external = false)
    if may_be_nonurl && !url.blank? && !url.start_with?("/") && !url.start_with?("http:")
      # Probably not a URL, just display raw text
      attribute_table_row(name, url)
    else
      attribute_table_row(name, url_or_blank(url, url_text, clipboard, linkclasses, external), url, nil)
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
  
  def attribute_table_row_boolean(name, val)
    attribute_table_row(name, val ? t("myplaceonline.general.yes") : t("myplaceonline.general.no"))
  end

  def attribute_table_row_reference(name, pathfunc, ref)
    if !ref.nil?
      url = send(pathfunc, ref)
      attribute_table_row(name, url_or_blank(url, ref.display), url)
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
  
  def url_or_blank(url, inner_content = nil, clipboard = nil, linkclasses = nil, external = false)
    if !url.to_s.empty?
      if inner_content.nil? || inner_content.to_s.empty?
        inner_content = url
      end
      
      options = Hash.new
      options[:href] = url
      options[:class] = ""
      
      # If it's probably external
      if external || (!url.start_with?("/") || url.start_with?("//"))
        options[:class] += " externallink"
        options[:target] = "_blank"
        options["data-ajax"] = "false"
      end
      if !clipboard.nil?
        options[:class] += " clipboardable"
        options["data-clipboard-text"] = html_escape(clipboard_text_str(clipboard))
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
  
  def myp_text_field(form, name, placeholder, value, autofocus = false, input_classes = nil, autocomplete = true)
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if autocomplete
      field = form.text_field(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value)
    else
      field = form.text_field(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value, autocomplete: "off")
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      field
    ).html_safe
  end
  
  def myp_number_field(form, name, placeholder, value, autofocus = false, input_classes = nil, step = nil)
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.send(Myp.use_html5_inputs ? "number_field" : "text_field", name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value, step: step)
    ).html_safe
  end
  
  def myp_decimal_field(form, name, placeholder, value, autofocus = false, input_classes = nil, step = Myp::DEFAULT_DECIMAL_STEP)
    myp_number_field(form, name, placeholder, value, autofocus, input_classes, step)
  end
  
  def myp_integer_field(form, name, placeholder, value, autofocus = false, input_classes = nil)
    myp_number_field(form, name, placeholder, value, autofocus, input_classes)
  end
  
  def myp_text_field_tag(name, placeholder, value, autofocus = false, input_classes = nil)
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      label_tag(name, placeholder, class: myp_label_classes(value)) +
      text_field_tag(name, value, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes))
    ).html_safe
  end
  
  def myp_datetime_field(form, name, placeholder, value, autofocus = false, input_classes = nil, override_datebox_type = nil)
    myp_date_field(form, name, placeholder, value, autofocus, input_classes, "datetime", Myplaceonline::DEFAULT_TIME_FORMAT)
  end
  
  def myp_date_field(form, name, placeholder, value, autofocus = false, input_classes = nil, override_datebox_type = nil, date_format = Myplaceonline::DEFAULT_DATE_FORMAT)
    # http://dev.jtsage.com/jQM-DateBox/api/
    # http://dev.jtsage.com/jQM-DateBox/doc/3-0-first-datebox/
    # Options should match app/assets/javascripts/myplaceonline_final.js form_add_item
    # https://github.com/jtsage/jquery-mobile-datebox/issues/363
    # https://github.com/jtsage/jquery-mobile-datebox/issues/295
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    
    hidden_time = nil
    random_name = ""
    close_callback = "false"
    element_type = "date_field"
    
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
          "data-datebox-close-callback" => "datebox_timebox_closed"
        )
        datebox_type = "calbox"
        close_callback = "datebox_calendar_closed"
        element_type = "datetime_local_field"
      end
    end
    if !Myp.use_html5_inputs
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
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if value.size.nil?
      value = nil
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.file_field(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value)
    ).html_safe
  end
  
  def is_probably_i18n(str)
    !str.nil? && str.include?("myplaceonline.")
  end

  def myp_text_area(form, name, placeholder, value, autofocus = false, input_classes = nil)
    # No need to set 'rows' or height because of autogrow:
    # https://github.com/jquery/jquery-mobile/blob/master/js/widgets/forms/autogrow.js
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(value)) +
      form.text_area(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), value: value)
    ).html_safe
  end

  def myp_text_area_markdown(form, name, placeholder, value, autofocus = false, input_classes = nil)
    myp_text_area(form, name, I18n.t(placeholder) + " (" + I18n.t("myplaceonline.general.supports_markdown") + ")", value, autofocus, input_classes)
  end

  def myp_check_box(form, name, placeholder, autofocus = false, input_classes = nil)
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.check_box(name, class: myp_field_classes(autofocus, input_classes)) +
      form.label(name, placeholder)
    ).html_safe
  end
  
  def myp_check_box_tag(name, placeholder, checked, autofocus = false, input_classes = nil, onclick = "")
    if is_probably_i18n(placeholder)
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
    if is_probably_i18n(placeholder)
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
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if regionvalue.blank?
      regionvalue = default_region
    end
    render(partial: 'myplaceonline/subregionselect', locals: { f: form, regionstr: regionvalue, subregion: subregionvalue })
  end

  def myp_subregion_select_field(form, name, placeholder, region, subregionvalue, autofocus = false, input_classes = nil)
    if is_probably_i18n(placeholder)
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
    if is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: myp_label_classes(selectvalue)) +
      form.select(name, options_for_select(selectoptions, selectvalue), class: myp_field_classes(autofocus, input_classes), prompt: placeholder, include_blank: !selectvalue.nil?)
    ).html_safe
  end
  
  def myp_select_tag(name, placeholder, selectoptions, selectvalue, autofocus = false, input_classes = nil, inline = false, onchange = nil)
    if is_probably_i18n(placeholder)
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
        result = Myp.categories[url.to_sym]
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
end
