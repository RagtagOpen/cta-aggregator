module V1
  class UserResource < BaseResource
    attribute :email
    relationship :advocacy_campaigns, to: :many
    relationship :targets, to: :many
    relationship :events, to: :many
    relationship :locations, to: :many
  end
end
