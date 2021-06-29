class BookingRoom < ApplicationRecord
  belongs_to :room
  has_many :booking_room_availabilities, dependent: :destroy

  enum status: %i[published draft]
end
