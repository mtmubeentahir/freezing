require 'rails_helper'
RSpec.describe Api::V1::ReadingsController do
  
  let!(:thermostat) { FactoryGirl.create(:thermostat) }
  let!(:reading1) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 1) }
  let!(:reading2) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 2) }
  let!(:reading3) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 3) }
  
  describe 'GET #readings show' do
    before do
      reading_id = { 'id': reading1.id }
      get "/api/v1/readings/#{thermostat.household_token}", params: reading_id
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'Response contains expected output' do
      data = JSON.parse(response.body)
      expect(data['temprature']).to eq(reading1.temprature)
      expect(data['humidity']).to eq(reading1.humidity)
      expect(data['battery_charge']).to eq(reading1.battery_charge)
      expect(data['sequence']).to eq(reading1.sequence)
    end

    it "JSON body response contains expected attributes" do
      data = JSON.parse(response.body)
      expect(data.keys.map(&:to_sym)).to match_array([:temprature, :humidity, :battery_charge, :sequence])
    end
  end

  describe 'POST #readings' do
    before do
      payload =  { 'reading': { 'temprature': 123.0, 'humidity': 3.123, 'battery_charge': 123.321 } }
      post "/api/v1/readings/#{thermostat.household_token}", params: payload
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'Verify sequence number' do
      data = JSON.parse(response.body)
      expect(data['sequence']).to eq(4)
    end

    it "JSON body response contains expected attributes" do
      data = JSON.parse(response.body)
      expect(data.keys.map(&:to_sym)).to match_array([:temprature, :humidity, :battery_charge, :sequence])
    end
  end

  describe 'GET #stats' do
    before do
      get "/api/v1/stats/#{thermostat.household_token}"
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it "JSON body response contains expected attributes" do
      data = JSON.parse(response.body)
      expect(data.keys.map(&:to_sym)).to match_array([:id, :household_token, :location, :minimum_temprature, :average_temprature, :maximum_temprature, :minimum_humidity, :average_humidity, :maximum_humidity, :minimum_battery_charge, :average_battery_charge, :maximum_battery_charge])
    end

    it 'Response contains expected temprature' do
      data = JSON.parse(response.body)
      expect(data['minimum_temprature']).to eq(thermostat.readings.minimum(:temprature))
      expect(data['average_temprature']).to eq(thermostat.readings.average(:temprature).to_i)
      expect(data['maximum_temprature']).to eq(thermostat.readings.maximum(:temprature))
    end

    it 'Response contains expected humidity' do
      data = JSON.parse(response.body)
      expect(data['minimum_humidity']).to eq(thermostat.readings.minimum(:humidity))
      expect(data['average_humidity']).to eq(thermostat.readings.average(:humidity).to_i)
      expect(data['maximum_humidity']).to eq(thermostat.readings.maximum(:humidity))
    end

    it 'Response contains expected battery_charge' do
      data = JSON.parse(response.body)
      expect(data['minimum_battery_charge']).to eq(thermostat.readings.minimum(:battery_charge))
      expect(data['average_battery_charge']).to eq(thermostat.readings.average(:battery_charge).to_i)
      expect(data['maximum_battery_charge']).to eq(thermostat.readings.maximum(:battery_charge))
    end
  end

end
