class AlertsController < ApplicationController
  def index
    render json: {
      alerts: Alert.where(email: params[:email])
    }
  end

  def create
    alert = Alert.new(alert_params)
    if alert.save
      render json: { alert: alert }
    else
      render json: {
        errors: alert.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    alert = Alert.find(params[:id])
    if alert.delete
      render json: nil
    else
      render json: {
        errors: alert.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def alert_params
    params.require(:alert).permit(:email, :symbol, :price)
  end
end
