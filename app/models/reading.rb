class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :sequence, presence: true

  # before_save :assign_sequence

  # def assign_sequence
  #   self.sequence = self.thermostat.readings.last&.sequence.to_i + 1
  # end

  def self.set_reading(thermostat, reading_id)
    job = Sidekiq::Queue.new('default').find { |job_id| reading_id }
    
    if job.blank?
      reading = thermostat.readings.find_by(reading_id: reading_id)
      return reading
    else
      values = job.item["args"].first["arguments"][1]
      values.delete('_aj_hash_with_indifferent_access')
      reading = Reading.new(values)
    end
    
  end
end
