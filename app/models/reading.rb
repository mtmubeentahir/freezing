class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :sequence, presence: true
end
