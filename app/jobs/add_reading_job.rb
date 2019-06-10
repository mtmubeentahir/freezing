class AddReadingJob < ApplicationJob
  queue_as :default

  def perform(thermostat_id, params)
    thermostat = Thermostat.find thermostat_id

    reading = thermostat.readings.new(params)
    
    reading.save!
  end
end
