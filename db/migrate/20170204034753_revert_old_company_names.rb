class RevertOldCompanyNames < ActiveRecord::Migration[5.0]
  def change
    Company.all.each do |company|
      MyplaceonlineExecutionContext.do_context(company) do
        i = company.company_identity
        if !i.middle_name.blank? && !i.last_name.blank?
          i.name += " #{i.middle_name} #{i.last_name}"
          i.middle_name = nil
          i.last_name = nil
          i.save!
        elsif !i.last_name.blank?
          i.name += " #{i.last_name}"
          i.last_name = nil
          i.save!
        elsif !i.middle_name.blank?
          i.name += " #{i.middle_name}"
          i.middle_name = nil
          i.save!
        end
      end
    end
  end
end
