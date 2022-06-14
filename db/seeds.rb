# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin_user = User.create(name: "Admin User", email: "admin@microverse.com", password: "password", role: "admin")
view_user1 = User.create!(name: "View User", email: "user@microverse.com", password: "password")
view_user2 = User.create!(name: "John", email: "john@microverse.com", password: "password")

admin_user.image.attach(io: File.open("#{Rails.root}/public/users/194934.png"), filename: '194934.png', content_type: 'image/png')
view_user1.image.attach(io: File.open("#{Rails.root}/public/users/194935.png"), filename: '194935.png', content_type: 'image/png')
view_user2.image.attach(io: File.open("#{Rails.root}/public/users/194938.png"), filename: '194938.png', content_type: 'image/png')

doctor1 = Doctor.create!(name: "Dr. John Doe", city: 'New York', specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist who specializes in heart disease. He is a certified heart surgeon and a member of the American Heart Association.')
doctor2 = Doctor.create!(name: "Dr. Jane Doe", city: 'New Jearsy', specialization: 'Nevrology', cost_per_day: 70, description: 'Dr. Jane Doe is a nevrologiest who specializes in heart disease. She is a certified heart surgeon and a member of the American Heart Association.')
doctor3 = Doctor.create!(name: "Rilind Zhaku", city: 'Struga', specialization: 'Cardiology', cost_per_day: 150, description: 'Dr. Rilind Zhaku is a cardiologist who specializes in heart disease. He is a certified heart surgeon and a member of the American Heart Association.')

doctor1.image.attach(io: File.open("#{Rails.root}/public/doctors/doctor1.jpg"), filename: 'doctor1.jpg', content_type: 'image/jpg')
doctor2.image.attach(io: File.open("#{Rails.root}/public/doctors/doctor2.jpg"), filename: 'doctor2.jpg', content_type: 'image/jpg')
doctor3.image.attach(io: File.open("#{Rails.root}/public/doctors/doctor3.jpg"), filename: 'doctor3.jpg', content_type: 'image/jpg')

apointment1 = Appointment.create!(doctor_id: doctor1.id, user_id: view_user1.id, date_of_appointment: Time.now)
apointment2 = Appointment.create!(doctor_id: doctor2.id, user_id: view_user1.id, date_of_appointment: Time.now)
apointment3 = Appointment.create!(doctor_id: doctor3.id, user_id: view_user1.id, date_of_appointment: Time.now)

