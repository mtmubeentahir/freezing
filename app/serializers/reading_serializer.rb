class ReadingSerializer < ActiveModel::Serializer
  attributes :temprature, :humidity, :battery_charge, :sequence
end
