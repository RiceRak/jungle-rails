require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user).to be_valid
    end

    it 'is not valid without a first name' do
      user = User.new(
        first_name: nil,
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors.full_messages).to include("First name can't be blank")
    end

    it 'is not valid without a last name' do
      user = User.new(
        first_name: 'John',
        last_name: nil,
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors.full_messages).to include("Last name can't be blank")
    end

    it 'is not valid without an email' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: nil,
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors.full_messages).to include("Email can't be blank")
    end

    it 'is not valid with a duplicate email' do
      User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user = User.new(
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
      user.valid?
      expect(user.errors.full_messages).to include("Email has already been taken")
    end

    it 'is not valid with a password shorter than 6 characters' do
      user = User.new(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'pass',
        password_confirmation: 'pass'
      )
      user.valid?
      expect(user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    before(:each) do
      @user = User.create(
        first_name: 'John',
        last_name: 'Doe',
        email: 'test@test.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'authenticates with valid credentials' do
      authenticated_user = User.authenticate_with_credentials('test@test.com', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'does not authenticate with invalid email' do
      authenticated_user = User.authenticate_with_credentials('wrong@test.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'does not authenticate with incorrect password' do
      authenticated_user = User.authenticate_with_credentials('test@test.com', 'wrong_password')
      expect(authenticated_user).to be_falsey
    end

    it 'authenticates with email with leading/trailing spaces' do
      authenticated_user = User.authenticate_with_credentials('  test@test.com  ', 'password')
      expect(authenticated_user).to eq(@user)
    end

    it 'authenticates with email in wrong case' do
      authenticated_user = User.authenticate_with_credentials('TeSt@TeSt.cOm', 'password')
      expect(authenticated_user).to eq(@user)
    end
  end
end
