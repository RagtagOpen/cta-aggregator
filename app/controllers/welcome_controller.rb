class WelcomeController < ApplicationController

  def index
    redirect_to v1_events_path
  end
end
