class ConvertHotelRating < ActiveRecord::Migration[5.2]
  def change
    Hotel.all.each do |hotel|
      MyplaceonlineExecutionContext.do_context(hotel) do
        hotel.rating = hotel.overall_rating
        hotel.save!
      end
    end
  end
end
