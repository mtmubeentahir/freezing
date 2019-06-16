class CreateReading
  def initialize(thermostat, params)
    @thermostat = thermostat
    @params = params
  end

  def create_reading
    job = AddReadingJob.perform_later(tid = @thermostat.id, @params)
    job.job_id
  end
end