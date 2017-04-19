module V1
  class UserResource < JSONAPI::Resource
    attribute :email
    relationship :ctas, to: :many
  end
end
