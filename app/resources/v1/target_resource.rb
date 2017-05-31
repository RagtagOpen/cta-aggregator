module V1
  class TargetResource < JSONAPI::Resource
    attributes :organization, :given_name, :family_name, :ocdid,
      :postal_addresses, :email_addresses, :phone_numbers

    before_save do
      @model.postal_addresses = Array(@model.postal_addresses).collect do |address|
        address[:address_lines] ||= []
        address.permit(:primary, :address_type, :venue, :locality, :region, :postal_code, :country, address_lines: []).to_h
      end

      @model.email_addresses = Array(@model.email_addresses).collect do |address|
        address.permit(:primary, :address, :address_type, :status).to_h
      end

      @model.phone_numbers = Array(@model.phone_numbers).collect do |phone|
        phone.permit(:primary, :number, :extension, :number_type).to_h
      end
    end

  end
end
