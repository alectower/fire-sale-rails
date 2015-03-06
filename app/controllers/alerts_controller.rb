class AlertsController < ApplicationController
  def index
    render json: Alert.where(email: params[:email])
  end

  def create
    alert = Alert.new(alert_params)
    if alert.save
      render json: alert
    else
      render json: alert.errors,
        status: :unprocessable_entity
    end
  end

  private

  def alert_params
    params.require(:alert).permit(:email, :symbol, :price)
  end
end
