module V1
  class LocationResource < JSONAPI::Resource
    attributes :address, :city, :state, :zipcode, :notes

    filters :address, :city, :state, :zipcode
  end
end
