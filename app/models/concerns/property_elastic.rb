require 'elasticsearch/model'

module PropertyElastic
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings index: { number_of_shards: 1 } do
      mappings dynamic: 'false' do
        indexes :id
        indexes :search_body, analyzer: 'snowball'
        indexes :property_options
        indexes :rooms, type: 'nested', properties: {
          'name' => {'type' => 'text'},
          'id' => {'type' => 'long'},
          'room_options' => {'type' => 'keyword'},
          'guests' => { 'type' => 'long'},
          'availability' => { 'type' => 'nested', properties: {
            'day' => { 'type' => 'date' },
            'id' => { 'type' => 'long' },
            'price' => {'type' => 'long'},
            'status' => { 'type' => 'keyword' },
            'booking_room_id' => { 'type' => 'long'}
          } }
        }
      end
    end
  end

  def as_indexed_json(_options = {})
    as_json(
      only: %i[id updated_at]
    ).merge({
      property_options: property_options.pluck(:id),
      search_body: title,
      rooms: availabilities,
      })
  end

  def availabilities
    if booking_rooms.any?
      booking_rooms.map do |br|
        {
          name: br.title,
          id: br.id,
          room_options: br.room.room_options.pluck(:id).uniq,
          guests: br.guests,
          availability: br.booking_room_availabilities.where("day >= ? AND day < ?", Date.today, Date.today + 6.months).map do |s|
            {day: s.day.to_s, price: s.price, status: s.status, room_id: br.id, id: s.id}
          end
        }
      end
    else
      rooms.map do |r|
        {
          name: r.title,
          id: r.id,
          room_options: r.room_options.pluck(:id).uniq,
        }
      end
    end
  end
end
