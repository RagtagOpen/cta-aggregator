class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
  include Knock::Authenticable

  def context
    { current_user: current_user }
  end
end
