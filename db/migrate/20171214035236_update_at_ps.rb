class UpdateAtPs < ActiveRecord::Migration[5.1]
  def change
    ApartmentTrashPickup.all.each do |atp|
      MyplaceonlineExecutionContext.do_context(atp) do
        atp.on_after_save
      end
    end
  end
end
