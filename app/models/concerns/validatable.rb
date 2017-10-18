module Validatable
  extend ActiveSupport::Concern

  included do
    validate :share_url_valid?, on: [:create, :update]
  end

  def share_url_valid?
    return unless share_url
    valid_url  = share_url.scan(URI.regexp).any?
    errors.add(:advocacy_campaign, 'invalid share_url') unless valid_url
  end
end
