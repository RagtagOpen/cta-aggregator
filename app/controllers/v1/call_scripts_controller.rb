module V1
  class CallScriptsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  end
end
