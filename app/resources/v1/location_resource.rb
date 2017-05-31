module V1
  class LocationResource < JSONAPI::Resource
    attributes :venue, :address_lines, :locality, :region, :postal_code

    filters :venue, :address_lines, :locality, :region, :postal_code
  end
end
