class StatsSerializer < ActiveModel::Serializer
  attributes :id, :household_token, :location,
             :minimum_temprature, :average_temprature, :maximum_temprature,
             :minimum_humidity, :average_humidity, :maximum_humidity,
             :minimum_battery_charge, :average_battery_charge, :maximum_battery_charge,
             :reading_counts


  def average_temprature
    object.readings.average(:temprature).to_i
  end

  def minimum_temprature
    object.readings.minimum(:temprature)
  end

  def maximum_temprature
    object.readings.maximum(:temprature)
  end

  def average_humidity
    object.readings.average(:humidity).to_i
  end

  def minimum_humidity
    object.readings.minimum(:humidity)
  end

  def maximum_humidity
    object.readings.maximum(:humidity)
  end

  def average_battery_charge
    object.readings.average(:battery_charge).to_i
  end

  def minimum_battery_charge
    object.readings.minimum(:battery_charge)
  end

  def maximum_battery_charge
    object.readings.maximum(:battery_charge)
  end

  def reading_counts
    object.readings.size
  end
end
