module V1
  class LocationResource < JSONAPI::Resource
    attributes :venue, :address_lines, :locality, :region, :postal_code

    filters :venue, :address_lines, :locality, :region, :postal_code

    has_one :user

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

  end
end
