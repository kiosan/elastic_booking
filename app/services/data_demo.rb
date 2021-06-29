class DataDemo
  PROPERTIES = ['White', 'Blue', 'Yellow', 'Red', 'Green']
  PROPERTY_OPTIONS = ['WiFi', 'Parking', 'Swimming Pool', 'Playground']
  ROOM_OPTIONS = ['Kitchen', 'Kettle', 'Work table', 'TV']
  ROOM_TYPES = ['Standard', 'Comfort']

  def self.search
    params = {}
    from_search = Date.today + rand(20).days
    params[:from] = from_search.to_s
    params[:to] = (from_search + 3.days).to_s
    params[:per_page] = 10
    property_options = PROPERTY_OPTIONS.sample(1).map{|po| PropertyOption.find_by title: po}
    room_options = ROOM_OPTIONS.sample(1).map{|ro| RoomOption.find_by title: ro}
    params[:property_options] = property_options.map(&:id).join(',')
    params[:room_options] = room_options.map(&:id).join(',')
    params[:guests] = 2

    res = BookingSearch.perform(params)

    puts "Search for dates: #{params[:from]}..#{params[:to]}"
    puts "Property options: #{property_options.map(&:title).to_sentence}"
    puts "Room options: #{room_options.map(&:title).to_sentence}"

    res.response.hits.hits.each do |hit|

      puts "Property: #{hit._source.search_body}"
      available_rooms = {}

      hit.inner_hits.each do |key, inner_hit|
        if key != 'room'
          inner_hit.hits.hits.each do |v|
            available_rooms[v._source.room_id.to_s] ||= []
            available_rooms[v._source.room_id.to_s] << { day: v._source.day, price: v._source.price }
          end
        else
          puts "Rooms: #{inner_hit.hits.hits.count}"
        end
      end

      available_rooms.each do |key, ar|
        booking_room = BookingRoom.find key
        puts "Room: #{booking_room.room.title} / #{booking_room.title}"
        total_price = 0

        ar.each do |day|
          puts "#{day[:day]}: $#{day[:price]}/night"
          total_price += day[:price]
        end

        puts "Total price for #{ar.count} #{'night'.pluralize(ar.count)}: $#{total_price}"
        puts "----------------------------\n"
      end
    end

    res.response.hits["total"].value
  end


  def self.delete
    Property.destroy_all
    PropertyOption.destroy_all
    RoomOption.destroy_all
  end

  def self.run

    delete

    PROPERTY_OPTIONS.each { |po| PropertyOption.create(title: po) }
    ROOM_OPTIONS.each { |ro| RoomOption.create(title: ro) }

    5.times do |i|
      p = Property.create(title: PROPERTIES[i])
      rooms = rand(2) + 1

      p.property_options = PROPERTY_OPTIONS.sample(2).map{ |po| PropertyOption.find_by title: po }

      rooms.times do |j|
        room = p.rooms.create({title: "#{ROOM_TYPES[rand(2)]} #{j}" })
        room.room_options = ROOM_OPTIONS.sample(2).map{ |po| RoomOption.find_by title: po }

        (rand(2) + 1).times do |k|
          booking_room = room.booking_rooms.create title: "Room #{k+1}", status: :published, guests: rand(4) + 1

          30.times do |d|
            booking_room.booking_room_availabilities.create day: Date.today + d.days, status: :available, price: [100, 200, 300][rand(3)]
          end
        end
      end
    end
    Property.__elasticsearch__.delete_index!
    Property.__elasticsearch__.create_index!
    Property.__elasticsearch__.import
  end
end
