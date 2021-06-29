class CreateBookingRoomAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_room_availabilities do |t|
      t.references :booking_room, null: false, foreign_key: true
      t.date :day
      t.integer :status

      t.timestamps
    end
  end
end
