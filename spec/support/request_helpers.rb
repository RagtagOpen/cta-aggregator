module Requests
  module JsonHelpers

    def json
      JSON.parse(response.body)
    end

    def json_resource(klass, instance, context={})
      JSONAPI::ResourceSerializer.new(klass).serialize_to_hash(klass.new(instance, context))
    end

    def json_api_headers
      { 'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => 'application/vnd.api+json' }
    end

    def json_api_headers_with_auth(user_id)
      token = Knock::AuthToken.new(payload: { sub: user_id }).token
      json_api_headers.merge('HTTP_AUTHORIZATION' => "Bearer #{token}")
    end

  end
end
