 class Api::V1::ReadingsController < ApplicationController
  before_action :authenticate_thermostat, only: [:show, :create, :stats]
  before_action :set_reading, only: [:show]

  def create
    #Scheduled a job
    job = AddReadingJob.perform_later(tid = @thermostat.id, merge_squence_params)

    #Saved job id as reading id in reading table and sent back in response to fetch data from scheduled job
    #if job is in queue and entry not created on DB
    render json: { status: 'InProgress', 
                   message: 'Reading is Inprogres', 
                   code: 200, 
                   data: {
                      reading_id: job.job_id, 
                      sequence: merge_squence_params['sequence']
                    }
                  }
  end

  def show
    render json: @reading
  end

  def stats
    render json: @thermostat, serializer: StatsSerializer
  end

  private
  def set_reading
    #get the scheduled JOB if any
    job = Sidekiq::Queue.new('default').find { |job_id| params[:reading_id] }
    
    if job.blank?
      #if job does not exist look into database for entry
      @reading = @thermostat.readings.find_by(reading_id: params[:reading_id])
      render json: {status: 'error', message: 'Reading doesnot exist', code: 404} if @reading.blank?
    else
      #Featch arguments from scheduled job  and return in response
      values = job.item["args"].first["arguments"][1]
      values.delete('_aj_hash_with_indifferent_access')
      @reading = Reading.new(values)
    end
  end

  def authenticate_thermostat
    @thermostat = Thermostat.find_by(household_token: params[:token])
    render json: {status: 'error', message: 'Thermostat doesnot exist', code: 404} if @thermostat.blank?
  end

  def reading_params
    params.require(:reading).permit(:temprature, :humidity, :battery_charge)
  end

  def merge_squence_params
    #calculate sequence number by adding value from last sequence number of the thermostat
    counter = @thermostat.readings.last&.sequence.to_i + 1
    #merge in params
    reading_params.merge!(sequence: counter)    
  end
end
