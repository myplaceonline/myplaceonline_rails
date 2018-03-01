class HelpController < ApplicationController
  skip_before_action :do_authenticate_user
  skip_authorization_check
  
  def index; end
  def features; end

  def highlights
    @categories = [
      Myp.categories[:trips]
    ]
  end

  def category
    if !params[:name].blank?
      @category = Myp.categories[params[:name]]
      if !@category.nil?
        @content = I18n.t("myplaceonline.help.category_#{@category.name}")
        if @content.blank? || @content.start_with?("translation missing")
          @content = I18n.t("myplaceonline.help.no_help")
        else
          @content = Myp.parse_yaml_to_html(@content)
          r = Regexp.new('{image:([^}]+)}')
          @content = @content.gsub(r) {|m| ActionController::Base.helpers.image_tag("#{$1}", class: "help_image")}
          @content = @content.html_safe
        end
      else
        @content = I18n.t("myplaceonline.help.category_unspecified")
      end
    else
    end
  end
end
