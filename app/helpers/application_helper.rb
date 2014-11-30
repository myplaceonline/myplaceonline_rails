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
  
  def attribute_table_row(name, value)
    html = <<-HTML
    <tr>
      <td>#{name}</td>
      <td>#{value}</td>
      <td>
        #{
          content_tag(
            :a,
            t("myplaceonline.general.clipboard"),
            href: "#",
            class: "ui-btn ui-icon-action ui-btn-icon-notext nomargin clipboardable",
            title: t("myplaceonline.general.clipboard"),
            data: { "clipboard-text" => value }
          )
        }
      </td>
    </tr>
    HTML
    
    html.html_safe
  end
end
