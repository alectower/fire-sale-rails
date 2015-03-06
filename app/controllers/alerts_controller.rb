class AlertsController < ApplicationController
  def index
    render json: Alert.where(email: params[:email])
  end
end
