module V1
  class CtasController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  end
end
