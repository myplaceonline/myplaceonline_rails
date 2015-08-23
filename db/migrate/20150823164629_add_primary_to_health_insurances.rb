class AddPrimaryToHealthInsurances < ActiveRecord::Migration
  def change
    add_reference :health_insurances, :doctor, index: true
    add_reference :dental_insurances, :doctor, index: true
  end
end
