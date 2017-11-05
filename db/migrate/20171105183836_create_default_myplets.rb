class CreateDefaultMyplets < ActiveRecord::Migration[5.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      domain = WebsiteDomain.where(identity_id: User::SUPER_USER_IDENTITY_ID, verified: true, domain_name: "myplaceonline").take!
      Myp.create_default_website_myplets(identity_id: User::SUPER_USER_IDENTITY_ID, website_domain: domain)
    end
  end
end
