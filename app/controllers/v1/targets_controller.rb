module V1
  class TargetsController < ApplicationController
    before_action :authenticate_user, except: [:show, :index]

    def create
      existing_target = Target.where(target_lookup_params).first

      if existing_target
        redirect_to(action: :show, id: existing_target.id)
      else
        super
      end

    end

    private

      def target_lookup_params
        params.require(:data).require(:attributes).permit(:organization, :given_name, :family_name, :ocdid)
      end

  end
end
