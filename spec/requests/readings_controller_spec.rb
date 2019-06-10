require 'rails_helper'
RSpec.describe Api::V1::ReadingsController do
  
  let!(:thermostat) { FactoryGirl.create(:thermostat) }

  let!(:reading1) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 1) }
  let!(:reading2) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 2) }
  let!(:reading3) { FactoryGirl.create(:reading, thermostat: thermostat, sequence: 3) }
  
  describe 'GET #readings' do
    before do
      get "/api/v1/readings/#{thermostat.household_token}"
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'Response contains expected count' do
      data = JSON.parse(response.body)
      expect(data.count).to eq(3)
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
      byebug
      data = JSON.parse(response.body)
      expect(data.keys.map(&:to_sym)).to match_array([:temprature, :humidity, :battery_charge, :sequence])
    end
  end


end
