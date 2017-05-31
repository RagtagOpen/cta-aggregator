module V1
  class LocationsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  def create
    existing_location = Location.where(location_lookup_params).first

    if existing_location
      redirect_to(action: :show, id: existing_location.id)
    else
      super
    end

  end

  private

    def location_lookup_params
      params.require(:data).require(:attributes).permit(:address_lines, :locality, :region, :postal_code)
    end

  end
end
