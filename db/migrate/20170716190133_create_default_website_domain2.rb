class CreateDefaultWebsiteDomain2 < ActiveRecord::Migration[5.1]
  def up
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      Myp.create_default_website
    end
  end

  def down
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      WebsiteDomain.where(default_domain: true).destroy_all
    end
  end
end
