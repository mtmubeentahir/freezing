 class Api::V1::ReadingsController < ApplicationController
  before_action :authenticate_thermostat, only: [ :show, :create ]

  def create
    reading = CreateReading.new(@thermostat.id, merge_squence_params)
    job_id = reading.create_reading
    render json: { status: 'InProgress', message: 'Reading is Inprogres', code: 200, data: { reading_id: job_id,  sequence: merge_squence_params['sequence'] } }
  end

  def show
    @reading = Reading.set_reading(@thermostat, params[:reading_id])
    data = @reading.blank? ? {status: 'error', message: 'Reading doesnot exist', code: 404} : @reading 
    render json: data
  end

  private
  def authenticate_thermostat
    @thermostat = Thermostat.find_by(household_token: params[:token])
    render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404} if @thermostat.blank?
  end

  def reading_params
    params.require(:reading).permit(:temprature, :humidity, :battery_charge)
  end

  def merge_squence_params
    counter = @thermostat.readings.last&.sequence.to_i + 1
    reading_params.merge!(sequence: counter)    
  end
end
