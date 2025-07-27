class TaskUser < ApplicationRecord
  CREATOR = "creator"
  ASSIGNEE = "assignee"
  ROLES = [ CREATOR, ASSIGNEE ].freeze

  belongs_to :user
  belongs_to :task

  validates :role, inclusion: { in: ROLES }
end
