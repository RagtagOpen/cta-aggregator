class WelcomeController < ApplicationController

  def index
    redirect_to v1_ctas_path
  end
end
