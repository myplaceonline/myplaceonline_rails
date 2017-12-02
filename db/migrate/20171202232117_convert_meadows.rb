class ConvertMeadows < ActiveRecord::Migration[5.1]
  def change
    Meadow.all.each do |meadow|
      MyplaceonlineExecutionContext.do_context(meadow) do
        meadow.trek = Trek.new(location: meadow.location)
        meadow.location = nil
        meadow.save!
      end
    end
  end
end
