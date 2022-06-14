require 'rails_helper'

RSpec.describe Appointment, type: :model do
  subject(:appointment) { create(:appointment) }

  describe 'validations' do
    it { expect(appointment).to validate_presence_of(:date_of_appointment) }
    let(:user) { User.create(name: 'Ally', email: 'test@test.com', password: '123456') }
    let(:doctor) do
      Doctor.create(name: 'Dr. John Doe', city: 'New York',
                    specialization: 'Cardiology', cost_per_day: 100, description: 'Dr. John Doe is a cardiologist.')
    end
    subject { described_class.new(date_of_appointment: '2000-10-10', user: user, doctor: doctor) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'that appointment belongs to user and doctor' do
      subject.save
      expect(user.appointments).to eq([subject])
      expect(doctor.appointments).to eq([subject])
      subject.destroy
    end

    it 'is not valid without a date_of_appointment' do
      subject.date_of_appointment = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a doctor_id' do
      subject.doctor_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
    it 'is not valid without a user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a doctor' do
      subject.doctor = nil
      expect(subject).to_not be_valid
    end

    describe 'Associations' do
      it { should belong_to(:user) }
      it { should belong_to(:doctor) }
    end
  end
end
