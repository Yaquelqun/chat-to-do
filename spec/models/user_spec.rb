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

  describe 'task associations' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe '#created_tasks' do
      it 'returns tasks where user is the creator' do
        created_task1 = create(:task, title: "Created Task 1")
        created_task2 = create(:task, title: "Created Task 2")
        assigned_task = create(:task, title: "Assigned Task")
        
        create(:task_user, user: user, task: created_task1, role: TaskUser::CREATOR)
        create(:task_user, user: user, task: created_task2, role: TaskUser::CREATOR)
        create(:task_user, user: user, task: assigned_task, role: TaskUser::ASSIGNEE)
        create(:task_user, user: other_user, task: created_task1, role: TaskUser::ASSIGNEE)

        expect(user.created_tasks).to include(created_task1, created_task2)
        expect(user.created_tasks).not_to include(assigned_task)
      end

      it 'orders tasks by created_at descending (most recent first)' do
        old_task = create(:task, title: "Old Task", created_at: 2.days.ago)
        new_task = create(:task, title: "New Task", created_at: 1.hour.ago)
        
        create(:task_user, user: user, task: old_task, role: TaskUser::CREATOR)
        create(:task_user, user: user, task: new_task, role: TaskUser::CREATOR)

        expect(user.created_tasks.first).to eq(new_task)
        expect(user.created_tasks.last).to eq(old_task)
      end

      it 'returns empty collection when user has created no tasks' do
        expect(user.created_tasks).to be_empty
      end
    end

    describe '#assigned_tasks' do
      it 'returns tasks where user is assigned (including created tasks)' do
        created_task = create(:task, title: "Created Task")
        assigned_task1 = create(:task, title: "Assigned Task 1")
        assigned_task2 = create(:task, title: "Assigned Task 2")
        other_task = create(:task, title: "Other Task")
        
        create(:task_user, user: user, task: created_task, role: TaskUser::CREATOR)
        create(:task_user, user: user, task: assigned_task1, role: TaskUser::ASSIGNEE)
        create(:task_user, user: user, task: assigned_task2, role: TaskUser::ASSIGNEE)
        create(:task_user, user: other_user, task: other_task, role: TaskUser::CREATOR)

        expect(user.assigned_tasks).to include(created_task, assigned_task1, assigned_task2)
        expect(user.assigned_tasks).not_to include(other_task)
      end

      it 'orders tasks by created_at descending (most recent first)' do
        old_task = create(:task, title: "Old Task", created_at: 2.days.ago)
        new_task = create(:task, title: "New Task", created_at: 1.hour.ago)
        
        create(:task_user, user: user, task: old_task, role: TaskUser::ASSIGNEE)
        create(:task_user, user: user, task: new_task, role: TaskUser::ASSIGNEE)

        expect(user.assigned_tasks.first).to eq(new_task)
        expect(user.assigned_tasks.last).to eq(old_task)
      end

      it 'returns empty collection when user has no assigned tasks' do
        expect(user.assigned_tasks).to be_empty
      end
    end
  end
end
