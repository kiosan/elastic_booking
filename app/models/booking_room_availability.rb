class BookingRoomAvailability < ApplicationRecord
  belongs_to :booking_room
  enum status: %i[available closed booked]

  validates_uniqueness_of :booking_room, scope: %i[day]
end
