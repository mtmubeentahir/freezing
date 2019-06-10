FactoryGirl.define do
  factory :reading do
    temprature { Faker::Number.between(-15, 70) }
    humidity { Faker::Number.between(15, 70) }
    battery_charge { Faker::Number.between(0, 100) }
  end
end