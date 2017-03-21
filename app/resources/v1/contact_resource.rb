module V1
  class ContactResource < JSONAPI::Resource
    attributes :name, :phone, :email, :website

    filters :name, :email
  end
end
