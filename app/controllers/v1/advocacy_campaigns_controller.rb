module V1
  class AdvocacyCampaignsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

    def create
      existing_advocacy_campaign = AdvocacyCampaign.where(advocacy_campaign_lookup_params).first

      if existing_advocacy_campaign
        redirect_to(action: :show, id: existing_advocacy_campaign.id)
      else
        super
      end

    end

    private

    def advocacy_campaign_lookup_params
      params.require(:data).require(:attributes).permit(:title, :browser_url)
    end

  end
end
