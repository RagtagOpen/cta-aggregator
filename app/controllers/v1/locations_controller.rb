module V1
  class LocationsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  end
end
