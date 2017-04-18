module V1
  class ContactsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

  end
end
