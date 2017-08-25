JSONAPI::Authorization.configure do |config|
  config.pundit_user = :current_user
end
