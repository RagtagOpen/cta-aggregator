class LocationResource < JSONAPI::Resource
  attributes :address_line_1, :address_line_2, :city, :state, :zipcode, :notes

  filters :address_line_1, :address_line_2, :city, :state, :zipcode
end
