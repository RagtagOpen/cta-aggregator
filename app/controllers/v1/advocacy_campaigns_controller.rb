module V1
  class AdvocacyCampaignsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  end
end
