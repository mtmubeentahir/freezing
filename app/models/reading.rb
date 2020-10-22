class Reading < ApplicationRecord
  belongs_to :thermostat
  validates :sequence, presence: true

  def self.set_reading(thermostat, reading_id)
    job = Sidekiq::Queue.new('default').find { |job_id| reading_id }
    return reading = thermostat.readings.find_by(reading_id: reading_id) || thermostat.readings if job.blank?
    values = job.item["args"].first["arguments"][1]
    values.delete('_aj_hash_with_indifferent_access')
    reading = Reading.new(values)
  end
end
