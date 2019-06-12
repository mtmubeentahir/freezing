class ReadingSerializer < ActiveModel::Serializer
  attributes :id, :temprature, :humidity, :battery_charge, :sequence
end
