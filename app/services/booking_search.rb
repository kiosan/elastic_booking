class BookingSearch
  def self.perform(params, page = 1)
    @page = page || 1
    @per_page = params[:per_page]
    @query = params[:q]&.strip
    @params = params
    search
  end

  def self.search

    salt = @params[:salt] || "salt"

    terms = {
      sort: {
        _script: {
          script: "(doc['_id'] + '#{salt}').hashCode()",
          type: "number",
          order: "asc"
        }
      },
      query: {
        bool: {
          must: search_terms,
          filter:  {
            bool: {
              must: generate_term + generate_nested_term
            }
          }
        }
      },
      size: @per_page,
      from: (@page.to_i - 1) * @per_page
    }
    Property.__elasticsearch__.search(terms)
  end

  def self.generate_nested_term
    terms_all = []

    terms = []
    if @params[:room_options]
      @params[:room_options].split(",")&.map(&:to_i)&.each do |ro|
        terms.push({terms: { "rooms.room_options" => [ro] }})
      end
    end
    terms.push({range: { "rooms.guests" => {'gte' => @params[:guests].to_i}}})
    n = {nested: {
      path: "rooms",
      query: {
        bool: {
          must: terms
        }
      },
      inner_hits: { name: 'room' }
    }}
    terms_all.push(n)


    Date.parse(@params[:from]).upto(Date.parse(@params[:to]) - 1.day) do |d|
      terms = []
      terms.push(match: { "rooms.availability.status" => 'available' })
      terms.push(match: { "rooms.availability.day" => d.to_s })
      n = {nested: {
        path: "rooms.availability",
        query: {
          bool: {
            must: terms
          }
        },
        inner_hits: { name: d.to_s }
      }
      }
      terms_all.push(n)
    end

    terms_all
  end

  def self.generate_term
    terms = []

    if @params[:property_options].present?
      @params[:property_options].split(',').each do |lo|
        terms.push(term: { property_options: lo })
      end
    end

    terms
  end

  def self.search_terms
    match = [@query.blank? ? { match_all: {} } : { multi_match: { query: @query, fields: %w[search_body], operator: 'and' } }]
    match.push( { ids: { values: @params[:ids] } }) if @params[:ids]
    match
  end
end
