class WelcomeController < ApplicationController

  def index
    redirect_to v1_advocacy_campaigns_path
  end
end
