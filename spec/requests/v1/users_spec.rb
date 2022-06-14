require 'rails_helper'

RSpec.describe 'v1/users/', type: :request do
  include RequestSpecHelper
  let(:access_token) { confirm_and_login_user }
  let(:Authorization) { "Bearer #{access_token}" }

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'return the token and user info' do
        post v1_users_signup_path, params: { name: 'test', email: 'test@test.com', password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['token']).to_not be nil
        expect(body['exp']).to_not be nil
        expect(body['user_details']).to_not be nil
        expect(body['user_details']['email']).to eq('test@test.com')
        expect(body['user_details']['name']).to eq('test')
      end
    end

    context 'with invalid parameters : User with the same email already created' do
      it 'return message error' do
        user = User.create(name: 'test', email: 'test@test.com', password: 'helloWORLD')
        post v1_users_signup_path, params: { name: 'test', email: 'test@test.com', password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['error']).to eq('forbidden')
        expect(body['error_message']['email']).to eq(['has already been taken'])
        user.destroy
      end
    end

    context 'with invalid parameters : Name is nil' do
      it 'return message error' do
        post v1_users_signup_path, params: { name: nil, email: 'test@test.com', password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['error']).to eq('forbidden')
        expect(body['error_message']['name']).to eq(['can\'t be blank', 'is too short (minimum is 3 characters)'])
      end
    end

    context 'with invalid parameters : Email is nil' do
      it 'return message error' do
        post v1_users_signup_path, params: { name: 'test', email: nil, password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['error']).to eq('forbidden')
        expect(body['error_message']['email']).to eq(['can\'t be blank'])
      end
    end

    context 'with invalid parameters : Password is nil' do
      it 'return message error' do
        post v1_users_signup_path, params: { name: 'test', email: 'test@test.com', password: '' }
        body = response.parsed_body
        expect(body['error']).to eq('forbidden')
        expect(body['error_message']['password']).to eq(['can\'t be blank', 'is too short (minimum is 6 characters)'])
      end
    end

    context 'with more parameters :' do
      it 'return the token and user info, others parameters are ignored' do
        post v1_users_signup_path,
             params: { name: 'test', email: 'test@test.com', password: 'helloWORLD', confirm_password: 'hello' }
        body = response.parsed_body
        expect(body['token']).to_not be nil
        expect(body['exp']).to_not be nil
        expect(body['user_details']).to_not be nil
        expect(body['user_details']['email']).to eq('test@test.com')
        expect(body['user_details']['name']).to eq('test')
        expect(body['user_details']['confirm_password']).to be nil
      end
    end
  end

  describe 'POST /login' do
    before(:all) do
      @user = FactoryBot.create(:user)
    end
    context 'with valid parameters' do
      it 'return the token and user info' do
        post '/v1/users/login', params: { email: @user.email, password: 'password' }
        body = response.parsed_body
        expect(body['token']).to_not be nil
        expect(body['exp']).to_not be nil
        expect(body['user_details']).to_not be nil
        expect(body['user_details']['email']).to eq(@user.email)
      end
    end

    context 'with invalid email : User tried to login with email that doesnt exist' do
      it 'return user does not exist' do
        post '/v1/users/login', params: { email: 'johndoe@test.com', password: 'helloWORLD' }
        body = response.parsed_body
        expect(body['error']).to eq('unauthorized')
        expect(body['error_message'][0]).to eq('User does not exist')
      end
    end

    context 'with invalid password : User exists but password is invalid' do
      it 'return invalid password' do
        post '/v1/users/login', params: { email: @user.email, password: 'wrongpassword' }
        body = response.parsed_body
        expect(body['error']).to eq('unauthorized')
        expect(body['error_message'][0]).to eq('invalid password')
      end
    end
  end

  describe 'GET /fetch_current_user' do
    context 'User details object is fetched successfully' do
      it 'returns user details object' do
        get '/v1/users/fetch_current_user', headers: { 'Authorization' => "Bearer #{access_token}" }
        body = response.parsed_body
        expect(body['data'].nil?).to_not be true
        expect(body['data']['email'].nil?).to be false
      end
    end
  end
end
