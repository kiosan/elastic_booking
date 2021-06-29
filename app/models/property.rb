class Property < ApplicationRecord
  include PropertyElastic

  has_many :rooms, dependent: :destroy
  has_many :booking_rooms, through: :rooms
  has_and_belongs_to_many :property_options, dependent: :destroy
end
