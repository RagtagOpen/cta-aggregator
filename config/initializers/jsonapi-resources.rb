JSONAPI.configure do |config|
  config.route_format = :underscored_route
  config.resource_key_type = :string
  config.json_key_format = :underscored_key

  config.default_paginator = :paged

  config.default_page_size = 10
  config.maximum_page_size = 30
end
