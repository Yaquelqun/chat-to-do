# Factory for Task model
# Corresponding tests: spec/models/task_spec.rb

FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    state { Task::TODO }

    trait :todo do
      state { Task::TODO }
    end

    trait :ongoing do
      state { Task::ONGOING }
    end

    trait :done do
      state { Task::DONE }
    end

    trait :with_creator do
      after(:create) do |task|
        create(:task_user, task: task, user: create(:user), role: TaskUser::CREATOR)
      end
    end

    trait :with_assignee do
      after(:create) do |task|
        create(:task_user, task: task, user: create(:user), role: TaskUser::ASSIGNEE)
      end
    end
  end
end
