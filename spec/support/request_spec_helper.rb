module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def confirm_and_login_user(user_role = 'admin')
    user = User.create(name: 'test', email: 'email@gmail.com', password: '123456', role: user_role)
    doctor = Doctor.create(name: 'Dr. John Doe', city: 'New York',
                           specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
    Appointment.create(date_of_appointment: '2000-09-07', doctor_id: doctor.id, user_id: user.id)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end

  def test_for_no_doctors
    user = FactoryBot.create(:user)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    json['token']
  end

  def login_and_delete_user(user_role = 'admin')
    user = User.create(name: 'test', email: 'email@gmail.com', password: '123456', role: user_role)
    post '/v1/users/login', params: { email: user.email, password: user.password }
    user.destroy
    json['token']
  end

  def login_and_create_appointment()
    user = User.create(name: 'test', email: 'emailtest2@gmail.com', password: '123456')
    post '/v1/users/login', params: { email: user.email, password: user.password }
    doctor = Doctor.create(name: 'Dr. John Doe', city: 'New York',
                           specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
    appointment = Appointment.create(date_of_appointment: '2000-09-07', doctor_id: doctor.id, user_id: user.id)

    { token: json['token'], id: appointment.id }
  end

  def login_without_appointment()
    User.create(name: 'test', email: 'emailtest2@gmail.com', password: '123456')
    post '/v1/users/login', params: { email: user.email, password: user.password }

    json['token']
  end
end
