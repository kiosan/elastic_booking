class AddPriceToRoomAvailability < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_room_availabilities, :price, :integer
  end
end
