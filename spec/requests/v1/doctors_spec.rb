require 'rails_helper'

RSpec.describe 'V1::Doctors', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }
  let(:token_without_create) { test_for_no_doctors }
  let(:user_access_token) { confirm_and_login_user('user') }

  describe 'GET /index' do
    before(:each) do
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns all doctors' do
      m = 0
      while m < 5
        FactoryBot.create(:doctor)
        m += 1
      end
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{access_token}" }
      json = JSON.parse(response.body)
      expect(json['data'].length).to be >= 5
      expect(json['message']).to eq(['All doctors loaded'])
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /doctors' do
    before(:each) do
      Doctor.destroy_all
      get '/v1/doctors', headers: { 'Authorization' => "Bearer #{token_without_create}" }
    end

    it 'returns no doctors found' do
      json = JSON.parse(response.body)
      expect(json['error']).to eq('not found')
      expect(json['error_message']).to eq(['No doctors found'])
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /doctors/:id' do
    before do
      doctor1 = Doctor.create(name: 'Doctor 2', city: 'Skopje', specialization: 'nervs', cost_per_day: 30, description: 'h
        eev ev ew v ewvewv')
      get "/v1/doctors/#{doctor1.id}", headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns the doctors with selected id' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST v1/doctors' do
    it 'creates a doctor' do
      post '/v1/doctors', params: { doctor: {
        name: 'Doctor 2',
        city: 'Skopje',
        specialization: 'nervs',
        cost_per_day: 30,
        description: 'description'
      } }, headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:created)
    end

    it 'not creates a doctor' do
      post '/v1/doctors', params: { doctor: {
        name: 'Doctor 2',
        city: 'Skopje',
        specialization: 'nervs',
        cost_per_day: 30,
        description: 'description'
      } }, headers: { 'Authorization' => "Bearer #{user_access_token}" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE v1/doctors/:id' do
    before(:each) do
      @doctor1 = Doctor.create(name: 'Doctor 2', city: 'Skopje', specialization: 'nervs', cost_per_day: 30, description: 'h
      eev ev ew v ewvewv')
    end
    it 'deletes a doctor with admin' do
      delete "/v1/doctors/#{@doctor1.id}",
             headers: { 'Authorization' => "Bearer #{access_token}" }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Doctor deleted successfully')
    end
    it 'deletes a doctor without admin' do
      delete "/v1/doctors/#{@doctor1.id}",
             headers: { 'Authorization' => "Bearer #{user_access_token}" }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('you need admin permision')
    end
  end
end
