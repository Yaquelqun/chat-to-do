# Factory for TaskUser model
# Corresponding tests: spec/models/task_user_spec.rb

FactoryBot.define do
  factory :task_user do
    user
    task
    role { TaskUser::CREATOR }

    trait :creator do
      role { TaskUser::CREATOR }
    end

    trait :assignee do
      role { TaskUser::ASSIGNEE }
    end
  end
end
