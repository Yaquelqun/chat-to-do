# Tests for User model
# Corresponding implementation: app/models/user.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires an email' do
      user = User.new(pseudo: 'testuser', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'requires a pseudo' do
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:pseudo]).to include("can't be blank")
    end

    it 'requires a password' do
      user = User.new(email: 'test@example.com', pseudo: 'testuser')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates email format' do
      user = User.new(pseudo: 'testuser', password: 'password123', email: 'invalid-email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'accepts valid email format' do
      user = User.new(pseudo: 'testuser', password: 'password123', email: 'test@example.com')
      expect(user.email).to eq('test@example.com')
    end

    it 'requires unique email (case insensitive)' do
      User.create!(email: 'TEST@EXAMPLE.COM', pseudo: 'user1', password: 'password123')
      user = User.new(email: 'test@example.com', pseudo: 'user2', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'requires unique pseudo' do
      User.create!(email: 'user1@example.com', pseudo: 'testuser', password: 'password123')
      user = User.new(email: 'user2@example.com', pseudo: 'testuser', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:pseudo]).to include('has already been taken')
    end

    it 'requires password confirmation when provided' do
      user = User.new(email: 'test@example.com', pseudo: 'testuser',
                     password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'email normalization' do
    it 'saves email in lowercase' do
      user = User.create!(email: 'TEST@EXAMPLE.COM', pseudo: 'testuser', password: 'password123')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'authentication' do
    let(:user) { User.create!(email: 'test@example.com', pseudo: 'testuser', password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.authenticate('password123')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end

    it 'has a password digest' do
      expect(user.password_digest).to be_present
      expect(user.password_digest).not_to eq('password123')  # Should be encrypted
    end
  end

  describe 'valid user creation' do
    it 'creates a valid user with all required attributes' do
      user = User.new(email: 'test@example.com', pseudo: 'testuser', password: 'password123')
      expect(user).to be_valid
      expect(user.save).to be true
    end
  end
end
