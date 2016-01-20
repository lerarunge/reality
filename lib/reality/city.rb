module Reality
  class City < Entity
    using Reality::Refinements
    
    # FIXME: have several descendant infobox classes
    infobox_name 'Infobox settlement'
    
    def long_name
      infobox.fetch('name').text.strip
    end

    def utc_offset
      infobox.fetch(/^utc_offset(1)?/).text.sub('−', '-').to_i
    end

    def population
      fetch_named_measure('population_total', 'person')
    end

    def population_metro
      fetch_named_measure('population_metro', 'person')
    end

    def area
      fetch_named_measure('area_total_km2', 'km²')
    end

    def country
      # TODO1: convert to "incomplete entry" of type Country
      # TODO2: can be {{UKR}}
      @country ||= infobox.
        fetch(/^subdivision_name/).sort_by(&:name).
        first.children.first.text.
        derp{|name| Reality::Country.new(name)}
    end

    def coord
      fetch_coord_dms
    end
  end

  def Reality.city(name)
    City.load(name)
  end
end
