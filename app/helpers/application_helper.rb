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
  
  def is_blank(value)
    value.nil? ||
      (value.is_a?(String) &&
        (value.strip.length == 0 || value == "&nbsp;"))
  end
  
  def attribute_table_row(name, value, clipboard_text = value, valueclass = "")
    if is_blank(value)
      return nil
    end
    html = <<-HTML
    <tr>
      <td>#{name}</td>
      <td class="#{valueclass}">#{value}</td>
      <td style="padding: 0.2em; vertical-align: top;">
        #{
          !is_blank(clipboard_text.to_s) ?
            content_tag(
              :a,
              t("myplaceonline.general.clipboard"),
              href: "#",
              class: "ui-btn ui-icon-action ui-btn-icon-notext nomargin clipboardable externallink",
              title: t("myplaceonline.general.clipboard"),
              data: { "clipboard-text" => html_escape("" + clipboard_text.to_s) }
            )
            : "&nbsp;"
        }
      </td>
    </tr>
    HTML
    
    html.html_safe
  end
  
  def attribute_table_row_url(name, url)
    attribute_table_row(name, url_or_blank(url), url)
  end
  
  def attribute_table_row_markdown(name, markdown)
    attribute_table_row(name, Myp.markdown_to_html(markdown), markdown, "markdowncell")
  end
  
  def attribute_table_row_boolean(name, val)
    attribute_table_row(name, val ? t("myplaceonline.general.yes") : t("myplaceonline.general.no"))
  end
  
  def url_or_blank(url, text = nil, clipboard = nil)
    if !url.to_s.empty?
      if text.to_s.empty?
        text = url
      end
      
      options = Hash.new
      options[:href] = url
      options[:class] = "externallink"
      options[:target] = "_blank"
      if !clipboard.nil?
        options[:class] += " clipboardable"
        options["data-clipboard-text"] = html_escape("" + clipboard.to_s)
      end
      
      content_tag(
        :a,
        text,
        options
      )
    else
      "&nbsp;"
    end
  end
  
  def display_time(time)
    time.in_time_zone(Rails.application.config.time_zone)
    #time.in_time_zone(ActiveSupport::TimeZone["Pacific Time (US & Canada)"])
  end
  
  def myp_text_area(form, name, placeholderid)
    # No need to set 'rows' or height because of autogrow:
    # https://github.com/jquery/jquery-mobile/blob/master/js/widgets/forms/autogrow.js
    form.text_area name, placeholder: t(placeholderid)
  end
end
