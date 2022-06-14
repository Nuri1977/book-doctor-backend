require 'rails_helper'

RSpec.describe Doctor, type: :model do
  subject(:doctor) { create(:doctor) }

  describe 'validations' do
    it { expect(doctor).to be_valid }
    it { expect(doctor).to validate_presence_of(:name) }
    it { expect(doctor).to validate_presence_of(:city) }
    it { expect(doctor).to validate_presence_of(:specialization) }
    it { expect(doctor).to validate_presence_of(:description) }
    it { expect(doctor).to validate_presence_of(:cost_per_day) }
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'cost per day should be integer' do
    subject.cost_per_day = 'text'
    expect(subject).to_not be_valid
  end

  it 'cost per day should not be negative' do
    subject.cost_per_day = -5
    expect(subject).to_not be_valid
  end

  it 'is valid without an image' do
    subject.image = nil
    expect(subject).to be_valid
  end

  describe 'Associations' do
    it { should have_many(:appointments) }
    it { should have_one_attached(:image) }
  end

  it 'is attached' do
    subject.image.attach(
      io: File.open(Rails.root.join('spec', 'fixtures', 'image.png')),
      filename: 'image.png',
      content_type: 'application/png'
    )
    expect(subject.image).to be_attached
  end
end
