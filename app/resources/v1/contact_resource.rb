module V1
  class ContactResource < JSONAPI::Resource
    attributes :name, :phone, :email, :website

    filter :name, apply: ->(records, value, _options) {
      records.where('lower(name) = ?', value[0].downcase)
    }

    filter :email, apply: ->(records, value, _options) {
      records.where(email: [value[0].downcase])
    }

  end
end
