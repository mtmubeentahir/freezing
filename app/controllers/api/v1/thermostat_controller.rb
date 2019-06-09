class Api::V1::ThermostatController < ApplicationController

  def index
    @thermostats = Thermostat.all
    render json: @thermostats
  end
end
