class ResetPeriodicPayments < ActiveRecord::Migration[5.1]
  def change
    PeriodicPayment.all.each do |x|
      MyplaceonlineExecutionContext.do_context(x) do
        x.on_after_save
      end
    end
  end
end
