class Room < ApplicationRecord

  belongs_to :property
  has_and_belongs_to_many :room_options
  has_many :booking_rooms, dependent: :destroy

end
