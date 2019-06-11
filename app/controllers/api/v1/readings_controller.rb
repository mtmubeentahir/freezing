class Api::V1::ReadingsController < ApplicationController
  before_action :authenticate_thermostat, only: [:index, :create, :stats]

  def create
    if @thermostat
      AddReadingJob.perform_later(@thermostat.id, reading_params)
      render json: @thermostat.readings.new(reading_params)
    else
      render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404}
    end
  end

  def index
    if @thermostat
      render json: @thermostat.readings
    else
      render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404}
    end
  end

  def stats
    if @thermostat
      render json: @thermostat, serializer: StatsSerializer
    else
      render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404}
    end
  end


  private
  def set_reading
    # @reading = Reading.find(params[:id])
  end

  def authenticate_thermostat
    @thermostat = Thermostat.find_by(household_token: params[:token])
  end

  def reading_params
    params.require(:reading).permit(:temprature, :humidity, :battery_charge).merge(sequence: @thermostat.readings.last&.sequence.to_a + 1)
  end
end
