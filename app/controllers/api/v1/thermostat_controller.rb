class Api::V1::ThermostatController < ApplicationController
  before_action :authenticate_thermostat, only: [:show, :create, :stats]

  def index
    @thermostats = Thermostat.all
    render json: @thermostats
  end

  def stats
    render json: @thermostat, serializer: StatsSerializer
  end

  private
  def authenticate_thermostat
    @thermostat = Thermostat.find_by(household_token: params[:token])
    render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404} if @thermostat.blank?
  end
end
