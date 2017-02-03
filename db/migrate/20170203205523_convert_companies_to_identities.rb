class ConvertCompaniesToIdentities < ActiveRecord::Migration[5.0]
  def change
    Company.all.each do |company|
      MyplaceonlineExecutionContext.do_context(company) do
        new_identity = Identity.create(
          name: company.name,
          notes: company.notes,
          identity_id: company.identity_id
        )
        puts "Created identity for #{company.name}"
        company.company_identity = new_identity
        company.save!

        if !company.location.nil?
          IdentityLocation.create(
            location_id: company.location_id,
            parent_identity_id: new_identity.id,
            identity_id: company.identity_id
          )
          company.update_columns(location_id: nil)
        end
      end
    end
  end
end
