class CreateBookingRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :booking_rooms do |t|
      t.references :room, null: false, foreign_key: true
      t.string :title
      t.integer :status

      t.timestamps
    end
  end
end
