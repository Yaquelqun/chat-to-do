# Unit tested in spec/models/user_spec.rb
class User < ApplicationRecord
  has_secure_password

  has_many :task_users, dependent: :destroy
  has_many :tasks, through: :task_users

  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :pseudo, presence: true, uniqueness: true

  before_save { self.email = email.downcase }

  # Returns tasks where the user is the creator
  def created_tasks
    tasks.joins(:task_users)
         .where(task_users: { role: TaskUser::CREATOR })
         .order(created_at: :desc)
  end

  # Returns tasks where the user is assigned (both created and assigned)
  def assigned_tasks
    tasks.order(created_at: :desc)
  end
end
