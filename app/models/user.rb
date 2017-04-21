class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_key

  has_many :ctas
  validates_presence_of :email
  validates_uniqueness_of :email

  before_save :normalize_email

  def self.from_token_request(request)
    self.find_by(api_key: TokenRequest.new(request).key)
  end

  private

  def normalize_email
    self.email = self.email.downcase
  end
end
