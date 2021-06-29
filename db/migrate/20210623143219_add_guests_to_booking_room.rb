class AddGuestsToBookingRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_rooms, :guests, :integer
  end
end
