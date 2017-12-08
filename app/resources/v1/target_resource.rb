module V1
  class TargetResource < BaseResource
    attributes :organization, :given_name, :family_name, :title, :ocdid,
      :postal_addresses, :email_addresses, :phone_numbers

    has_one :user

    before_create do
      @model.user_id = context[:current_user].id if @model.new_record?
    end

    filter :id #without this, console error appears 'failed to load resource' when filtering advocacy campaigns by target id

    # This callback might look like it's focused on formatting input data correctly
    # but it's actually necessary for formatting the *output* data.
    # It helps JSONAPI Resources to serialize arrays of hashes, specifically:
    # postal address, emails, and phone numbers.
    # Without this callback, JSONAPI Resources would render them as
    # ActionController::Parameters objects.

    before_save do
      @model.postal_addresses = Array(@model.postal_addresses).collect do |address|
        if params_present?(address)
          address[:address_lines] ||= []
          address.permit(:primary, :address_type, :venue, :locality, :region, :postal_code, :country, address_lines: []).to_h
        end
      end

      @model.email_addresses = Array(@model.email_addresses).collect do |address|
        if params_present?(address)
          address.permit(:primary, :address, :address_type, :status).to_h
        end
      end

      @model.phone_numbers = Array(@model.phone_numbers).collect do |phone|
        if params_present?(phone)
          phone.permit(:primary, :number, :extension, :number_type).to_h
        end
      end
    end

    private

    # Used to avoid calling `permit` when attribute is a hash.
    # Happens when updating preexisting record where changes proposed,
    # but not to this particular attribute
    # e.g. changing given name but not postal_addresses
    def params_present?(attribute)
      attribute.is_a? ActionController::Parameters
    end

  end
end
