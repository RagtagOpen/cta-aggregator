class TokenRequest
  def initialize(request)
    @key, @secret = request.authorization.split(":")
  end

  attr_reader :key, :secret
end
