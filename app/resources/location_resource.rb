class LocationResource < JSONAPI::Resource
  attributes :address_line1, :address_line2, :city, :state, :postal_code, :notes

  filters :address_line1, :address_line2, :city, :state, :postal_code
end
