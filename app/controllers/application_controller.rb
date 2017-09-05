class ApplicationController < ActionController::API
  include JSONAPI::ActsAsResourceController
  include Knock::Authenticable
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def context
    { current_user: current_user }
  end

  def user_not_authorized
    head :forbidden
  end
end
