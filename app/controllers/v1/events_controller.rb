module V1
  class EventsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

    def create
      existing_event = Event.where(event_lookup_params).first

      if existing_event
        redirect_to(action: :show, id: existing_event.id)
      else
        super
      end
    end

    private

      def event_lookup_params
        the_params = params.require(:data).require(:attributes).permit(:title, :browser_url)
        if params[:data].fetch(:relationships, {}).fetch(:location, {}).present?
          the_params[:location_id] = params[:data].fetch(:relationships, {}).fetch(:location, {}).fetch(:data, {}).fetch(:id)
        end
        the_params
      end

  end
end
