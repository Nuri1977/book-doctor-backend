# rubocop:disable Metrics/BlockLength
require 'swagger_helper'

RSpec.describe 'v1/appointments', type: :request do
  include RequestSpecHelper

  let(:Authorization) { "Bearer #{confirm_and_login_user}" }
  let(:parameter_request) { login_and_create_appointment }
  let(:user) { FactoryBot.create(:user) }
  let(:doctor) do
    Doctor.create(name: 'Dr. John Doe', city: 'New York',
                  specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
  end

  path '/v1/appointments' do
    get('list appointments') do
      tags 'Appointments'
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      response(200, 'Get all appointment for a user') do
        schema type: :object,
               properties: {
                 message: { type: :array,
                            items: {
                              type: :string

                            } },
                 data: { type: :array,
                         items: { type: :object,
                                  properties: {
                                    user_id: { type: :integer },
                                    date_of_appointment: { type: :string },
                                    imageUrl: { type: :string, nullable: true },
                                    doctor_id: { type: :integer },
                                    doctor: { type: :object,
                                              properties: {
                                                id: { type: :integer },
                                                name: { type: :string },
                                                city: { type: :string },
                                                specialization: { type: :string },
                                                cost_per_day: { type: :integer },
                                                description: { type: :string }
                                              } }
                                  } } }
               }

        run_test!
      end

      response(404, 'No appointment') do
        schema type: :object,
               properties: {
                 message: { type: :array,
                            items: {
                              type: :string

                            } },
                 error: { type: :string }
               }

        let(:Authorization) { login_without_appointment }

        run_test!
      end
    end

    post('create appointment') do
      tags 'Appointments'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          date_of_appointment: { type: :string },
          doctor_id: { type: :string }
        },
        require: %w[doctor_id date_of_appointment]
      }

      response(201, 'Appointment created') do
        let(:params) { { date_of_appointment: '2000/09/07', doctor_id: doctor.id } }
        schema type: :object,
               properties: {
                 message: { type: :string },
                 data: { type: :object,
                         properties: {
                           doctor_id: { type: :integer },
                           date_of_appointment: { type: :string }
                         } }
               }

        run_test!
      end

      response '403', 'Appointment not created' do
        let(:params) { { date_of_appointment: '2000/99/97', doctor_id: -1 } }
        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_message: { type: :object,
                                  properties: {
                                    doctor: { type: :array },
                                    date_of_appointment: { type: :array }
                                  } }

               }

        run_test!
      end
    end
  end

  path '/v1/appointments/{id}' do
    delete('delete appointment') do
      tags 'Appointments'
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string
      parameter name: :id, in: :path, type: :string

      response(200, 'successful') do
        let(:id) { parameter_request[:id] }
        let(:Authorization) { "Bearer #{parameter_request[:token]}" }

        schema type: :object,
               properties: {
                 message: { type: :array,
                            items: { type: :string } },
                 data: { type: :object,
                         properties: {
                           doctor_id: { type: :integer },
                           date_of_appointment: { type: :string },
                           user_id: { type: :integer }

                         } }
               }

        run_test!
      end

      response(404, 'not found') do
        let(:id) { parameter_request[:id] }

        schema type: :object,
               properties: {
                 error: { type: :string },
                 error_message: { type: :array,
                                  items: { type: :string } }

               }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
