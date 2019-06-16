class CreateReading
  def initialize(thermostat_id, params)
    @thermostat_id = thermostat_id
    @params = params
  end

  def create_reading
    job = AddReadingJob.perform_later(@thermostat_id, @params)
    job.job_id
  end
end