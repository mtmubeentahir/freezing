class ReadingSerializer < ActiveModel::Serializer
  attributes :id, :temprature, :humidity, :battery_charge, :sequence, :reading_id
end
