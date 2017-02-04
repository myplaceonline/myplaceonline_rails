class SetCompanyIdentityTypes < ActiveRecord::Migration[5.0]
  def change
    Company.all.each do |company|
      MyplaceonlineExecutionContext.do_context(company) do
        company.company_identity.identity_type = Identity::IDENTITY_TYPE_COMPANY
        company.company_identity.save!
      end
    end
  end
end
