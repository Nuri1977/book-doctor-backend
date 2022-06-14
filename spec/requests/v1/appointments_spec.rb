require 'rails_helper'

RSpec.describe 'V1::Appointments', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }
  let(:access_token_invaid) { login_and_delete_user }
  let(:Authorization) { "Bearer #{access_token}" }
  let(:user_token) { confirm_and_login_user }

  describe 'GET /index' do
    before(:each) do
      get '/v1/appointments', headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns all appointments' do
      m = 0
      while m < 5
        FactoryBot.create(:appointment)
        m += 1
      end
      get '/v1/appointments', headers: { 'Authorization' => "Bearer #{access_token}" }
      json = JSON.parse(response.body)
      expect(json['data'].length).to be >= 1
      expect(json['message']).to eq(['All appointments loaded'])
      expect(response).to have_http_status(:ok)
    end

    it 'returns an error' do
      Appointment.destroy_all
      get '/v1/appointments', headers: { 'Authorization' => "Bearer #{user_token}" }
      json = JSON.parse(response.body)
      expect(json['error_message']).to eq(['No appointments found'])
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /appointments/:id' do
    before do
      appointment1 = Appointment.create(date_of_appointment: '2019-01-01', doctor_id: 1, user_id: 1)
      get "/v1/appointments/#{appointment1.id}", headers: { 'Authorization' => "Bearer #{access_token}" }
    end

    it 'returns the appointments with selected id' do
      expect(response).to have_http_status(:ok)
    end
  end

  let(:doctor) do
    Doctor.create(name: 'Dr. John Doe', city: 'New York',
                  specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
  end

  let(:user) do
    User.create(name: 'test', email: 'emaildeletee1@gmail.com', password: '123456')
  end

  describe 'DELETE v1/appointments/:id' do
    it 'delete appointment' do
      appointment = Appointment.create(date_of_appointment: '2019-01-01', doctor_id: doctor.id, user_id: user.id)
      post '/v1/users/login', params: { email: user.email, password: user.password }

      delete "/v1/appointments/#{appointment.id}", headers: { 'Authorization' => "Bearer #{json['token']}" }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE v1/appointments/:id' do
    it 'can not delete appointment (bad user)' do
      appointment = Appointment.create(date_of_appointment: '2019-01-01', doctor_id: doctor.id, user_id: user.id)

      delete "/v1/appointments/#{appointment.id}", headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE v1/appointments/:id' do
    it 'can not delete appointment (bad appointment)' do
      appointment = Appointment.create(date_of_appointment: '2019-01-01', doctor_id: doctor.id, user_id: user.id)
      appointment.delete

      delete "/v1/appointments/#{appointment.id}", headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST v1/appointments' do
    it 'creates an appointment' do
      doctor.save
      post '/v1/appointments', params: { doctor_id: doctor.id, date_of_appointment: '2022/09/07' },
                               headers: { 'Authorization' => "Bearer #{access_token}" }

      expect(response).to have_http_status(:created)
      doctor.destroy
    end
  end

  describe 'POST v1/appointments' do
    it 'Error token, the appointment is not created' do
      doctor.save
      post '/v1/appointments', params: { doctor_id: doctor.id, date_of_appointment: '2022/09/07' },
                               headers: { 'Authorization' => "Bearer #{access_token_invaid}" }

      expect(response).to have_http_status(:unauthorized)
      doctor.destroy
    end
  end
end
