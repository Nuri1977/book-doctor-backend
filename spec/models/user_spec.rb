require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(email: 'test@test.com', password: 'helloWORLD', name: 'test', role: 'admin') }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without an email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a password' do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a password less than 6 characters' do
    subject.password = 'a' * 4
    expect(subject).to_not be_valid
  end

  it 'is not valid without a password more than 20 characters' do
    subject.password = 'a' * 30
    expect(subject).to_not be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a name length less than 3 characteres ' do
    subject.name = 'a'
    expect(subject).to_not be_valid
  end

  it 'is not valid if name length is more than 150 characters' do
    subject.name = 'a' * 160
    expect(subject).to_not be_valid
  end

  it 'is valid without a role (default role = user)' do
    subject.role = nil
    expect(subject).to be_valid
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
