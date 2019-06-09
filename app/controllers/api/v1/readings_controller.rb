class Api::V1::ReadingsController < ApplicationController
  before_action :authenticate_thermostat, only: [:show, :create, :stats]


  def create
    @reading = @thermostat.readings.new(reading_params)
    @reading.sequence = @thermostat.readings.size
    @reading.save!

    render json: {sequence: @reading.sequence}
  end

  def show
    
  end

  def stats
    
  end


  private
  def set_reading
    # @reading = Reading.find(params[:id])
  end

  def authenticate_thermostat
    @thermostat = Thermostat.find_by(household_token: params[:token])
  end

  def reading_params
    params.require(:reading).permit(:temprature, :humidity, :battery_charge)
  end
end
