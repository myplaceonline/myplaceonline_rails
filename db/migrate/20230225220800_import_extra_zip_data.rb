class ImportExtraZipData < ActiveRecord::Migration[6.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      contents = File.read(Rails.root.join('lib', 'data', 'zip_code_lookup', 'zip_incomes.csv'))
      data = []
      CSV.parse(contents, headers: true, skip_blanks: true) do |row|
        name = row["NAME"]
        name = name[6..-1]
        households = row["S1901_C01_001E"]
        mean_income = row["S1901_C01_013E"]
        zipCode = UsZipCode.where(zip_code: name).take
        if !zipCode.nil?
          zipCode.households = households.to_i
          zipCode.mean_income = mean_income.to_i
          zipCode.save!
        else
          puts "Warning: Zip #{name} not found"
        end
      end
    end
  end
end
