class UpdateDefaultHomepage < ActiveRecord::Migration[5.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      d = WebsiteDomain.where(default_domain: true).take!
      d.static_homepage = Myp.parse_yaml_to_html("myplaceonline.default_domain.homepage")
      d.save!
    end
  end
end
