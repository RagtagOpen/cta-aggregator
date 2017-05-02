module V1
  class UserTokenController < Knock::AuthTokenController
    private

    def auth_params
      token = ::TokenRequest.new(request)

      # NOTE: Knock wants you to get your token using a username and password
      # from a post body. This is bad from a security standpoint, so instead we
      # grab it from the request headers. See lib/token_request.rb for details.
      { email: token.key, password: token.secret }
    end
  end
end
