FactoryGirl.define do
  factory :thermostat do
    location {Faker::Address.full_address}
    household_token {Faker::Code.nric}
  end
end