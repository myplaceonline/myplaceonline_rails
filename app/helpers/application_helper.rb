require 'htmlentities'

module ApplicationHelper
  
  def flashes!(obj = nil)

    flash_params = params[:flash]

    Rails.logger.debug{"flashes: #{flash.inspect}, obj: #{obj.inspect}, flash_params: #{flash_params.inspect}"}
    
    if flash.empty? && (obj.nil? || (!obj.nil? && obj.errors.empty?)) && flash_params.nil?
      ""
    else
      messages = flash.map { |name, msg| content_tag(:li, msg.html_safe) }.join
      if !obj.nil? && obj.errors.any?
        Rails.logger.debug{"object flashes: #{obj.errors.inspect}"}
        obj.errors.each do |attribute, error|
          # If the first letter of the error is uppercase, then assume it was an overriden message
          attr = attribute.to_s
          package = obj.class.table_name
          ri = attr.rindex(".")
          if !ri.nil?
            package = attr[0..ri-1].pluralize
            i = package.index(".")
            if !i.nil?
              package = package[i+1..-1]
            end
            attr = attr[ri+1..-1]
          end
          li_html = I18n.t("myplaceonline." + package + "." + attr) + ": " + error
          messages += content_tag(
            :li,
            li_html.html_safe
          )
        end
      end
      if !flash_params.nil? && flash_params.has_key?("notice")
        messages += content_tag(:li, flash_params["notice"].html_safe)
      end

      html = <<-HTML
      <div class="errors">
        <ul>#{messages}</ul>
      </div>
      HTML

      html = html.html_safe
      
      Rails.logger.debug{"final flashes: #{html}"}
    
      html
    end
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
      options["data-clipboard-text"] = clipboard_text_str(clipboard_text)
      
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
  
  def clipboard_text_str(clipboard_text, encode_entities: true, strip_markdown: true)
    result = ""
    if !clipboard_text.blank?
      result = clipboard_text.to_s
      if ExecutionContext.count > 0 && !User.current_user.nil? && User.current_user.clipboard_transform_numbers
        # Haven't been able to find out where, but in some cases, trying to
        # use the firefox clipboard SDK to copy values that look
        # like credit cards to the clipboard are actually suppressed.
        if (result.length == 15 && result.gsub(/[^0-9]+/, "").length == 15) || (result.length == 16 && result.gsub(/[^0-9]+/, "").length == 16)
          result += " "
        end
      end
      if strip_markdown
        result = Myp.markdown_for_plain_email(result)
      end
    end
    if encode_entities
      result = CGI::escapeHTML(result)
    end
    result
  end
  
  def data_table_start(format: :html)
    # https://api.jquerymobile.com/table-reflow/
    %{
      <table data-role="table" data-mode="reflow" class="ui-responsive tablestripes normalwidth firstcolumnbold noheadertable">
        <thead>
          <tr>
            <th></th>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tbody>
    }.html_safe
  end
  
  def data_table_end(format: :html)
    %{
        </tbody>
      </table>
    }.html_safe
  end
  
  def display_string(content:, format:, options:)
    content.to_s
  end
  
  def display_date(content:, format:, options:)
    Myp.display_date(content, current_user)
  end
  
  def display_time(content:, format:, options:)
    if options[:onlytime]
      Myp.display_time(content, current_user, :simple_time)
    else
      Myp.display_datetime(content, current_user)
    end
  end
  
  def display_boolean(content:, format:, options:)
    content ? I18n.t("myplaceonline.general.y") : I18n.t("myplaceonline.general.n")
  end
  
  def display_url(content:, format:, options:)
    if !content.blank?
      if options[:url_innercontent].blank?
        options[:url_innercontent] = content
      end

      url_options = Hash.new
      url_options[:href] = content
      url_options[:class] = ""
      
      options[:clipboard_text] = content
      
      # If it's probably external
      if options[:url_external] || (!content.start_with?("/") || content.start_with?("//"))
        if options[:url_external_target_blank]
          url_options[:target] = "_blank"
        end
        url_options["data-ajax"] = "false"
      end
      if !options[:url_clipboard].blank?
        url_options[:class] = "clipboardable #{url_options[:class]}"
        url_options["data-clipboard-text"] = clipboard_text_str(options[:url_clipboard])
        url_options["data-clipboard-clickthrough"] = "yes"
      end
      if !options[:url_linkclasses].blank?
        url_options[:class] = "#{options[:url_linkclasses]} #{url_options[:class]}"
      end
      
      options[:htmlencode_content] = false
      
      content_tag(
        :a,
        CGI::escapeHTML(options[:url_innercontent]),
        url_options,
        escape = false
      )
    else
      nil
    end
  end
  
  def display_reference(content:, format:, options:)
    options[:controller_name] ||= content.class.name.pluralize + "Controller"
    options[:htmlencode_content] = false
    content_display = content.display
    options[:clipboard_text] = content_display

    if content.current_user_owns?
      url = send(content.class.name.underscore + "_path", content)
      result = display_url(
        content: url,
        format: :html,
        options: {
          url_innercontent: content_display
        }
      )
    else
      result = CGI::escapeHTML(content_display).html_safe
    end
    
    begin
      if ExecutionContext.push_marker(:nest_count) <= ExecutionContext.get(:max_nest, default: 1)
        options[:second_row] = renderActionInOtherController(
          Object.const_get(options[:controller_name]),
          :show,
          {
            id: content.id,
            nested_show: true,
            nested_expanded: options[:expanded]
          }
        ).html_safe
      end
    ensure
      ExecutionContext.pop_marker(:nest_count)
    end
    result
  end
  
  def display_collection(content:, format:, options:)
    options[:htmlencode_content] = false
    options[:wrap] = false
    options[:non_wrap_container] = nil
    result = ""
    path = content.class.to_s
    path = path[0..path.index("::")-1].underscore.pluralize
    if path.end_with?("_files")
      result = render(
        partial: "myplaceonline/pictures",
        locals: {
          pics: content,
          placeholder: options[:heading]
        }
      ).html_safe
    else
      content.each do |item|
        
        Rails.logger.debug{"ApplicationHelper.display_collection: item: #{item}, path: #{path}, heading: #{options[:heading]}"}
        
        child_html = render(partial: "#{path}/show", locals: { obj: item }).html_safe
        child_html = <<-HTML
          <tr>
            <td>#{CGI::escapeHTML(options[:heading])}</td>
            <td colspan="2">
              <div data-role="collapsible" data-collapsed="#{!options[:expanded]}">
                <h3>#{item.display}</h3>
                #{data_table_start(format: format)}
                #{child_html}
                #{data_table_end(format: format)}
              </div>
            </td>
          </tr>
        HTML
        result += child_html.html_safe
      end
    end
    result
  end
  
  def data_row(heading:, content:, **options)
    options = {
      content_classes: nil,
      format: :html,
      background_highlight: false,
      skip_blank_content: true,
      markdown: false,
      hide_false: false,
      url: false,
      url_external: false,
      url_external_target_blank: false,
      url_linkclasses: nil,
      url_clipboard: nil,
      url_innercontent: nil,
      htmlencode_content: true,
      wrap: true,
      heading: heading,
      onlytime: false,
      currency: false,
      tooltip: nil,
      enumeration: nil,
      expanded: false,
      max_nest: nil,
      prefix_heading: false,
      prefix_wrapper: :b,
      prefix_separator: ": ",
      non_wrap_container: :p
    }.merge(options)
    
    original_content = content
    
    if !options[:enumeration].nil?
      content = Myp.get_select_name(content, options[:enumeration])
    end
    
    # ->(content:, format:, options: ){ content.to_s }
    if options[:transform].nil?
      if content.is_a?(Fixnum) || content.is_a?(BigDecimal)
        options[:transform] = method(:display_string)
      elsif content.is_a?(ActiveSupport::TimeWithZone) || content.is_a?(Time) || content.is_a?(DateTime)
        options[:transform] = method(:display_time)
      elsif content.is_a?(Date)
        options[:transform] = method(:display_date)
      elsif content.is_a?(TrueClass) || content.is_a?(FalseClass)
        options[:transform] = method(:display_boolean)
      elsif content.is_a?(ApplicationRecord)
        options[:transform] = method(:display_reference)
      elsif content.is_a?(ActiveRecord::Associations::CollectionProxy)
        options[:transform] = method(:display_collection)
      end
    elsif options[:transform].is_a?(Symbol)
      options[:transform] = method(options[:transform])
    end

    if (content.is_a?(TrueClass) || content.is_a?(FalseClass)) && options[:hide_false] && !content
      return nil
    end
    
    if options[:url]
      options[:transform] = method(:display_url)
    end
    
    if !options[:transform].nil?
      ExecutionContext.stack(max_nest: options[:max_nest]) do
        content = options[:transform].call(content: content, format: options[:format], options: options)
      end
    end
    
    if content.blank? && options[:skip_blank_content]
      return nil
    end
    
    options[:clipboard_text] ||= content
    
    case options[:format]
    when :html
      if options[:markdown]
        options[:clipboard_text] = content
        content = Myp.markdown_to_html(content)
        options[:htmlencode_content] = false
        options[:content_classes] = "markdowncell #{options[:content_classes]}"
      end
      if !options[:clipboard_text].blank?
        link_options = Hash.new
        link_options[:href] = "#"
        link_options[:class] = "ui-btn ui-icon-action ui-btn-icon-notext nomargin clipboardable"
        link_options[:title] = t("myplaceonline.general.clipboard")
        link_options["data-clipboard-text"] = clipboard_text_str(options[:clipboard_text])
        
        options[:secondary_content] = content_tag(
          :a,
          t("myplaceonline.general.clipboard"),
          link_options,
          escape = false
        )
      else
        options[:secondary_content] = "&nbsp;"
      end
      
      if options[:htmlencode_content]
        content = CGI::escapeHTML(content)
      end
      
      if options[:background_highlight]
        options[:content_classes] = "bghighlight #{options[:content_classes]}"
      end
      
      if options[:warning] && original_content.is_a?(TrueClass)
        options[:content_classes] = "bgwarning #{options[:content_classes]}"
      end

      if options[:wrap]
        html = <<-HTML
          <tr>
            <td>#{content_tag(:span, CGI::escapeHTML(heading), class: "tooltipable", title: options[:tooltip])}</td>
            <td class="#{options[:content_classes]}">#{content}</td>
            <td style="padding: 0.2em; vertical-align: top;">#{options[:secondary_content]}</td>
          </tr>
        HTML
      else
        if options[:prefix_heading]
          if options[:prefix_wrapper].nil?
            html = CGI::escapeHTML(heading) + options[:prefix_separator] + content
          else
            html = content_tag(options[:prefix_wrapper], CGI::escapeHTML(heading) + options[:prefix_separator]) + content
          end
        else
          html = content
        end
        if !options[:non_wrap_container].nil?
          html = content_tag(options[:non_wrap_container], html)
        end
      end
      
      if !options[:second_row].blank?
        html += options[:second_row]
      end
      
      html.html_safe
    else
      raise "Unknown format #{options[:format]}"
    end
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
    
    token = share_token(context: identity_file)
    
    html = <<-HTML
    <audio src="#{file_view_name_path(identity_file, identity_file.urlname, t: identity_file.updated_at.to_i, token: token)}" preload="none" controls>
      <p>#{I18n.t("myplaceonline.html5.noaudio")}</p>
    </audio>
    #{ url_or_blank(file_download_path(identity_file, t: identity_file.updated_at.to_i, token: token), t("myplaceonline.files.download"), nil, "ui-btn ui-btn-inline", true) }
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
  
  def file_video(identity_file)
    
    token = share_token(context: identity_file)
    
    html = <<-HTML
    <video style="max-width: 100%;" src="#{file_view_name_path(identity_file, identity_file.urlname, t: identity_file.updated_at.to_i, token: token)}" preload="none" loop="true" controls>
      <p>#{I18n.t("myplaceonline.html5.novideo")}</p>
    </video>
    #{ url_or_blank(file_download_path(identity_file, t: identity_file.updated_at.to_i, token: token), t("myplaceonline.files.download"), nil, "ui-btn ui-btn-inline", true) }
    HTML
  end
  
  def attribute_table_row_file_video(name, identity_file)
    if !identity_file.nil? && !identity_file.file_content_type.nil? && identity_file.file_content_type.start_with?("video")
      html = file_video(identity_file)
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
          file_download_url(identity_file, t: identity_file.updated_at.to_i),
          t("myplaceonline.files.download"),
          nil,
          "externallink",
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
    
    token = share_token(context: identity_file)
    
    if has_image(identity_file)
      identity_file.ensure_thumbnail
      
      # Include a unique query parameter all the time because the thumbnail
      # may have been updated
      if has_thumbnail(identity_file)
        if useParams
          content =
              image_tag(
                file_thumbnail_name_path(
                  identity_file,
                  identity_file.urlname,
                  t: identity_file.updated_at.to_i,
                  token: token
                ),
                alt: identity_file.display,
                title: identity_file.display,
                class: "fit"
              )
        else
          content =
              image_tag(
                file_thumbnail_name_path(
                  identity_file,
                  identity_file.urlname,
                  t: identity_file.updated_at.to_i
                ),
                alt: identity_file.display,
                title: identity_file.display,
                class: "fit"
              )
        end
      else
        if useParams
          content =
              image_tag(
                file_view_name_path(
                  identity_file,
                  identity_file.urlname,
                  t: identity_file.updated_at.to_i,
                  token: token
                ),
                alt: identity_file.display,
                title: identity_file.display,
                class: "fit"
              )
        else
          content =
              image_tag(
                file_view_name_path(
                  identity_file,
                  identity_file.urlname,
                  t: identity_file.updated_at.to_i
                ),
                alt: identity_file.display,
                title: identity_file.display,
                class: "fit"
              )
        end
      end
      if link_to_original
        if useParams
          url_or_blank(
            file_view_name_url(
              identity_file,
              identity_file.urlname,
              t: identity_file.updated_at.to_i,
              token: token
            ),
            content,
            nil,
            "externallink",
            true
          )
        else
          url_or_blank(
            file_view_name_url(
              identity_file,
              identity_file.urlname,
              t: identity_file.updated_at.to_i
            ),
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
  
  def share_token(context:)
    
    token = params[:token]
    
    Rails.logger.debug{"ApplicationHelper.share_token: params[:token] = #{token}"}
    
    if token.blank?
      # If Ability.context_identity is different from the current user, then it could be, for example, a shared
      # (or nested) item which we can assume has already passed authorization checks, so we need to create a token for
      # the subsequent image request (because Ability.context_identity won't be set on the image request).
      
      Rails.logger.debug{"ApplicationHelper.share_token: context identity = #{Ability.context_identity.id}, current user = #{User.current_user.primary_identity_id}"}
      
      if Ability.context_identity.id != User.current_user.primary_identity_id
        
        # Check if we've already done this first
        existing_permission_share = PermissionShare.includes(:share).where(
          identity: User.current_user.primary_identity,
          subject_class: context.class.name,
          subject_id: context.id
        ).first
        
        if existing_permission_share.nil?
          share = Share.build_share(owner_identity: User.current_user.primary_identity)
          share.save!
          
          PermissionShare.create!(
            identity: User.current_user.primary_identity,
            share: share,
            subject_class: context.class.name,
            subject_id: context.id
          )
          
          token = share.token
        else
          token = existing_permission_share.share.token
        end
      end
    end
    
    token
  end
  
  def attribute_table_row_image(name, identity_file, link_to_original = true)
    content = image_content(identity_file, link_to_original)
    
    token = share_token(context: identity_file)
    
    if !content.nil?
      
      content +=
        "<p>#{
                url_or_blank(
                  file_path(
                    identity_file,
                    t: identity_file.updated_at.to_i,
                    token: token
                  ),
                  identity_file.file_file_name,
                  nil,
                  "",
                  true
                )
             } | #{
                    url_or_blank(
                      file_download_name_url(
                        identity_file,
                        identity_file.urlname,
                        t: identity_file.updated_at.to_i,
                        token: token
                      ),
                      t("myplaceonline.files.download"),
                      nil,
                      "externallink",
                      true
                    )
                  }</p>".html_safe
      
      if !identity_file.notes.blank?
        content += Myp.markdown_to_html(identity_file.notes).html_safe
      end
      attribute_table_row_content(
        name,
        nil,
        content
      )
    else
      if !identity_file.nil?
        if identity_file.urlname.blank?
          download_path =
              file_download_url(
                identity_file,
                t: identity_file.updated_at.to_i,
                token: token
              )
        else
          download_path =
              file_download_name_url(
                identity_file,
                identity_file.urlname,
                t: identity_file.updated_at.to_i,
                token: token
              )
        end
        content =
            "<p>#{
                    url_or_blank(
                      file_path(
                        identity_file,
                        t: identity_file.updated_at.to_i,
                        token: token
                      ),
                      identity_file.file_file_name,
                      nil,
                      "",
                      true
                    )
                  } | #{
                          url_or_blank(
                            download_path,
                            t("myplaceonline.files.download"),
                            nil,
                            "externallink",
                            true
                          )
                        }</p>".html_safe

        if !identity_file.notes.blank?
          content += Myp.markdown_to_html(identity_file.notes).html_safe
        end
        attribute_table_row_content(
          name,
          nil,
          content
        )
      else
        nil
      end
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
      begin
        if ExecutionContext.push_marker(:nest_count) <= 1
          render_result = renderActionInOtherController(
              Object.const_get(controllerName.nil? ? ref.class.name.pluralize + "Controller" : controllerName),
              :show,
              {
                id: ref.id,
                nested_show: true
              }
            ).html_safe
          result += render_result
        end
      ensure
        ExecutionContext.pop_marker(:nest_count)
      end
      result
    else
      nil
    end
  end
  
  def attribute_table_row_date(name, d)
    attribute_table_row(name, d.nil? ? nil : Myp.display_date(d, current_user))
  end
  
  def attribute_table_row_date_month_year(name, d)
    attribute_table_row(name, d.nil? ? nil : Myp.display_date_month_year(d, current_user))
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
  
  def attribute_table_row_weight(name, val, weight_type, weight_types: Myp::WEIGHTS)
    if !val.nil? && !weight_type.nil?
      select_name = Myp.get_select_name(weight_type, weight_types)
      paren_index = select_name.index(" (")
      suffix = ""
      if !paren_index.nil?
        suffix = select_name[paren_index..-1]
        select_name = select_name[0..paren_index-1]
      end
      row_value = ActionController::Base.helpers.pluralize(val, select_name.singularize) + suffix
      attribute_table_row(name, row_value)
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
        options["data-clipboard-text"] = clipboard_text_str(clipboard)
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
  def myp_label_classes(value, force_hidden: false)
    force_hidden || is_blank(value, false) ? "ui-hidden-accessible" : "form_field_label"
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
  
  def input_field(name:, type:, **options)
    options = {
      wrapper_tag: :p,
      include_label: true,
      placeholder: "",
      value: nil,
      form: nil,
      type: type,
      flexible: false,
      field_attributes: {},
      autofocus: false,
      field_classes: "",
      remote_autocomplete_model: nil,
      remote_autocomplete_all: false, # if true, show all items on focus; otherwise, show only items that match what's typed
      tooltip: nil,
      select_options: nil,
      translate_select_options: true,
      text_area_rich: true
    }.merge(options)
    
    input_method_prefix = "_field"
    
    if options[:type] == Myp::FIELD_NUMBER || options[:type] == Myp::FIELD_DECIMAL
      if options[:type] == Myp::FIELD_DECIMAL
        options = {
          step: Myp::DEFAULT_DECIMAL_STEP
        }.merge(options)
        options[:type] = :text
      end
      if !Myp.use_html5_inputs || options[:flexible]
        options[:type] = :text
      end
    elsif options[:type] == Myp::FIELD_DATE || options[:type] == Myp::FIELD_DATETIME || options[:type] == Myp::FIELD_TIME
      options = {
        datebox_mode: options[:type],
        date_format: options[:type] == Myp::FIELD_DATETIME || options[:type] == Myp::FIELD_TIME ? Myplaceonline::DEFAULT_TIME_FORMAT : Myplaceonline::DEFAULT_DATE_FORMAT
      }.merge(options)

      # Tried the date, datetime, and datetime_local tags, but they have various quirks, so override
      options[:type] = Myp::FIELD_TEXT
      
      # If autofocus is true but there's already a date/time value, we're probably just editing, so don't bother
      # to focus
      if options[:autofocus] && !options[:value].blank?
        options[:autofocus] = false
      end
    elsif options[:type] == Myp::FIELD_TEXT_AREA
      if options[:text_area_rich]
        options = {
          collapsible: true,
          collapsed: options[:value].blank?
        }.merge(options)
        
        # The collapsible header is effectively the label
        options[:include_label] = false
      else
        input_method_prefix = ""
      end
    elsif options[:type] == Myp::FIELD_SELECT
      if options[:translate_select_options]
        options[:select_options] = Myp.translate_options(options[:select_options], sort: true)
      end
    end

    if Myp.is_probably_i18n(options[:placeholder])
      options[:placeholder] = I18n.t(options[:placeholder])
    end
    
    result = nil
    
    if options[:include_label]
      if options[:type] != Myp::FIELD_BOOLEAN
        # We only want to show the label if value is blank and there's no tooltip
        label_classes = (options[:value].blank? && options[:tooltip].blank?) ? "ui-hidden-accessible" : "form_field_label"
      else
        # Rails creates two input elements for a checkbox which means we can't use
        # the trick to wrap a checkbox with a label as per:
        # https://www.w3.org/TR/html401/interact/forms.html#h-17.9.1
        # Instead we use the explicitly enhanced form as per ("Providing pre-rendered markup"):
        # http://api.jquerymobile.com/checkboxradio/
        label_classes = Myp.appendstr(label_classes, "ui-btn ui-btn-inherit ui-btn-icon-left")
        
        if options[:value]
          label_classes = Myp.appendstr(label_classes, "ui-checkbox-on")
        else
          label_classes = Myp.appendstr(label_classes, "ui-checkbox-off")
        end
      end
      
      if options[:form].nil?
        result = Myp.appendstr(
          result,
          label_tag(name, options[:placeholder], class: label_classes, title: options[:tooltip])
        )
      else
        result = Myp.appendstr(
          result,
          options[:form].label(name, options[:placeholder], class: label_classes, title: options[:tooltip])
        )
      end
    end
    
    field_attributes = options[:field_attributes]
    if options[:form].nil? && options[:type] != Myp::FIELD_BOOLEAN
      field_attributes[:value] = options[:value]
    end
    field_attributes[:placeholder] = options[:placeholder]
    if options[:autofocus]
      field_attributes[:class] = Myp.appendstr(field_attributes[:class], "autofocus")
    end
    if !options[:field_classes].nil?
      field_attributes[:class] = Myp.appendstr(field_attributes[:class], options[:field_classes])
    end
    if options[:type] != :text && !options[:step].nil?
      field_attributes[:step] = options[:step]
    end
    if options[:type] == Myp::FIELD_BOOLEAN
      field_attributes[:data] = { enhanced: "true" }
    end
    if options[:type] == Myp::FIELD_SELECT
      field_attributes[:prompt] = options[:placeholder]
      field_attributes[:include_blank] = !options[:value].nil?
    end

    if options[:datebox_mode].nil?
      if options[:type] == Myp::FIELD_TEXT_AREA && options[:text_area_rich]
        result = Myp.appendstr(
          result,
          render(partial: "myplaceonline/rte", locals: {
            f: options[:form],
            markdown_data: options[:value],
            hidden_field_name: name,
            autofocus: options[:autofocus]
          })
        )
        
        if options[:collapsible]
          result = "<div data-role=\"collapsible\" data-collapsed=\"#{options[:collapsed]}\"><h4>#{options[:placeholder]}</h4>".html_safe + result.html_safe + "</div>".html_safe
        end
      else
        if !options[:form].nil?
          if options[:type] == Myp::FIELD_BOOLEAN
            result = Myp.appendstr(
              result,
              options[:form].check_box(name, field_attributes)
            )
          elsif options[:type] == Myp::FIELD_SELECT
            result = Myp.appendstr(
              result,
              options[:form].send(
                options[:type].to_s,
                name,
                options_for_select(options[:select_options], options[:value]),
                field_attributes
              )
            )
          else
            result = Myp.appendstr(
              result,
              options[:form].send(
                options[:type].to_s + input_method_prefix,
                name,
                field_attributes
              )
            )
          end
        else
          if options[:type] == Myp::FIELD_BOOLEAN
            Rails.logger.debug{"ApplicationHelper.input_field: non-form boolean, value: #{(options[:value] ? true : false)}"}
            result = Myp.appendstr(
              result,
              check_box_tag(name, "true", (options[:value] ? true : false), field_attributes)
            )
          elsif options[:type] == Myp::FIELD_SELECT
            result = Myp.appendstr(
              result,
              send(
                options[:type].to_s + "_tag",
                name,
                options_for_select(options[:select_options], options[:value]),
                field_attributes
              )
            )
          else
            result = Myp.appendstr(
              result,
              send(
                options[:type].to_s + "#{input_method_prefix}_tag",
                name,
                options[:value],
                field_attributes
              )
            )
          end
        end
      end
      
      if !options[:remote_autocomplete_model].nil?
        id = extract_id(result)
        autocomplete_id = id + "_remote_autocomplete"
        remote_autocomplete_all_script = ""
        if options[:remote_autocomplete_all]
          remote_autocomplete_all_script = <<-eos
            $("##{id}").on("focus", function() {
              myplaceonline.listviewSearch($("##{autocomplete_id}"), "/api/distinct_values.json?table_name=#{options[:remote_autocomplete_model]}&column_name=#{name}", null);
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
          <ul data-role="listview" data-inset="true" data-filter="true" data-filter-reveal="#{options[:remote_autocomplete_all] ? false : true}" data-input="##{id}" id="#{autocomplete_id}">
          </ul>
          <script type="text/javascript">
            myplaceonline.onPageLoad(function() {
              $("##{autocomplete_id}").on("click", "li", function() {
                $("##{id}").val($(this).text());
                $("##{autocomplete_id} li").addClass("ui-screen-hidden");
              });
              myplaceonline.hookListviewSearch($("##{autocomplete_id}"), "/api/distinct_values.json?table_name=#{options[:remote_autocomplete_model]}&column_name=#{name}");
              
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
    else
      # http://dev.jtsage.com/jQM-DateBox/api/
      # http://dev.jtsage.com/jQM-DateBox/doc/3-0-first-datebox/
      # Options should match app/assets/javascripts/myplaceonline_final.js formAddItem
      # https://github.com/jtsage/jquery-mobile-datebox/issues/363
      # https://github.com/jtsage/jquery-mobile-datebox/issues/295
      
      hidden_time = nil
      random_name = ""
      close_callback = "false"
      mode = "calbox"
      
      case options[:datebox_mode]
      when Myp::FIELD_DATETIME
        random_name = SecureRandom.hex(10)
        hidden_time = hidden_field_tag(
          random_name,
          options[:value].blank? ? "" : options[:value].to_s(:timebox),
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
      when Myp::FIELD_TIME
        mode = "timebox"
      end
      
      field_attributes["data-role"] = "datebox"
      field_attributes["data-datebox-mode"] = mode
      field_attributes["data-datebox-override-date-format"] = options[:date_format]
      field_attributes["data-datebox-use-focus"] = "true"
      field_attributes["data-datebox-use-clear-button"] = "true"
      field_attributes["data-datebox-use-modal"] = "false"
      field_attributes["data-datebox-cal-use-pickers"] = "true"
      field_attributes["data-datebox-cal-year-pick-min"] = "-100"
      field_attributes["data-datebox-cal-year-pick-max"] = "10"
      field_attributes["data-datebox-cal-no-header"] = "true"
      field_attributes["data-datebox-close-callback"] = close_callback
      field_attributes["data-datetime-id"] = random_name
      
      # datebox or calbox
      result = Myp.appendstr(
        result,
        options[:form].send(
          options[:type].to_s + "_field",
          name,
          field_attributes
        ) + hidden_time
      )
    end
    
    if options[:type] == Myp::FIELD_BOOLEAN
      result = content_tag(:div, result.html_safe, class: "ui-checkbox")
    end

    if !options[:wrapper_tag].nil?
      result = content_tag(options[:wrapper_tag], result.html_safe)
    end
    
    result.html_safe
  end
  
  def myp_number_field_tag(name, placeholder, value, autofocus = false, input_classes = nil, step = nil, options = {})
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
      label_tag(name, placeholder, class: myp_label_classes(value)) +
      form.send(Myp.use_html5_inputs ? "number_field_tag" : "text_field_tag", name, baseoptions.merge(options))
    ).html_safe
  end
  
  def myp_decimal_field(form, name, placeholder, value, autofocus = false, input_classes = nil, step = Myp::DEFAULT_DECIMAL_STEP, options = {})
    myp_number_field(form, name, placeholder, value, autofocus, input_classes, step, options)
  end
  
  def myp_integer_field(form, name, placeholder, value, autofocus = false, input_classes = nil)
    myp_number_field(form, name, placeholder, value, autofocus, input_classes)
  end
  
  def myp_integer_field_tag(form, name, placeholder, value, autofocus = false, input_classes = nil)
    myp_number_field_tag(form, name, placeholder, value, autofocus, input_classes)
  end
  
  def myp_text_field_tag(name, placeholder, value, autofocus = false, input_classes = nil, wrapper_classes: nil, force_label_hidden: false)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :p,
      label_tag(name, placeholder, class: myp_label_classes(value, force_hidden: force_label_hidden)) +
      text_field_tag(name, value, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes)),
      class: wrapper_classes
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

  def myp_file_field(form, name, placeholder, value, autofocus = false, input_classes = nil, useprogress: false)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    if value.size.nil?
      value = nil
    end
    content_tag(
      :p,
      form.label(name, placeholder, class: "form_field_label") +
      form.file_field(name, placeholder: placeholder, class: myp_field_classes(autofocus, input_classes), data: { useprogress: useprogress })
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

  def myp_text_area_markdown(form, name, placeholder, value, autofocus = false, input_classes = nil, collapsed: true)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    result = render(partial: 'myplaceonline/rte', locals: {
      f: form,
      markdown_data: value,
      hidden_field_name: name
    })

    if collapsed.nil? || !value.blank?
      final_html = form.label(name, placeholder, class: "form_field_label") + result + "<br />".html_safe
    else
      final_html = "<div data-role=\"collapsible\" data-collapsed=\"#{collapsed}\"><h4>#{placeholder}</h4>".html_safe + form.label(name, placeholder, class: "form_field_label ui-hidden-accessible") + result + "</div>".html_safe
    end
    final_html
  end
  
  # Rails creates two input elements for a checkbox which means we can't use
  # the trick to wrap a checkbox with a label as per:
  # https://www.w3.org/TR/html401/interact/forms.html#h-17.9.1
  # Instead we use the explicitly enhanced form as per ("Providing pre-rendered markup"):
  # http://api.jquerymobile.com/checkboxradio/
  def myp_check_box(form, name, placeholder, autofocus = false, input_classes = nil, title: nil)
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :div,
      form.label(name, placeholder, title: title, class: "ui-btn ui-btn-inherit ui-btn-icon-left ui-checkbox-off") +
      form.check_box(name, class: myp_field_classes(autofocus, input_classes), data: { enhanced: "true" }),
      class: "ui-checkbox"
    ).html_safe
  end
  
  def myp_check_box_tag(name, placeholder, checked, autofocus = false, input_classes = nil, onclick = "")
    if Myp.is_probably_i18n(placeholder)
      placeholder = I18n.t(placeholder)
    end
    content_tag(
      :div,
      label_tag(name, placeholder, class: "ui-btn ui-btn-inherit ui-btn-icon-left ui-checkbox-off") +
      check_box_tag(name, true, checked, class: myp_field_classes(autofocus, input_classes), data: { enhanced: "true" }, onclick: onclick),
      class: "ui-checkbox"
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
    r = controller.make_response!(request)
    c.dispatch(action, request, r)
    if r.response_code == 302
      # Assume password required redirect
      raise Myp::DecryptionKeyUnavailableError
    end
    r.body
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
  
  def collapsible(heading:, collapsed: false, &block)
    content_tag(
      :div,
      content_tag(
        :h3,
        heading
      ) + block.call,
      data: { role: "collapsible", collapsed: collapsed.to_s }
    ).html_safe
  end

  def table_row_span(&block)
    content_tag(
      :tr,
      content_tag(
        :td,
        block.call,
        colspan: 3,
      ),
      class: "tablerowspan"
    ).html_safe
  end

  def attribute_table(&block)
    content_tag(
      :table,
      content_tag(
        :thead,
        content_tag(
          :tr,
          content_tag(
            :th,
            nil
          ) + content_tag(
            :th,
            nil
          ) + content_tag(
            :th,
            nil
          )
        )
      ) + content_tag(
        :tbody,
        block.call
      ),
      class: "ui-responsive tablestripes normalwidth firstcolumnbold noheadertable fontweightnormal",
      data: {
        role: "table",
        mode: "reflow"
      }
    ).html_safe
  end
end
