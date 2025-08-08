# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample users
puts "Creating users..."

users_data = [
  {
    email: "alice@example.com",
    pseudo: "alice_cooper",
    password: "password123"
  },
  {
    email: "bob@example.com",
    pseudo: "bob_builder",
    password: "password123"
  },
  {
    email: "charlie@example.com",
    pseudo: "charlie_brown",
    password: "password123"
  },
  {
    email: "diana@example.com",
    pseudo: "diana_prince",
    password: "password123"
  },
  {
    email: "eve@example.com",
    pseudo: "eve_online",
    password: "password123"
  }
]

users = []
users_data.each do |user_attrs|
  user = User.find_or_create_by!(email: user_attrs[:email]) do |u|
    u.pseudo = user_attrs[:pseudo]
    u.password = user_attrs[:password]
  end
  users << user
  puts "Created user: #{user.pseudo} (#{user.email})"
end

# Create sample tasks
puts "\nCreating tasks..."

tasks_data = [
  {
    title: "Set up development environment",
    state: Task::DONE
  },
  {
    title: "Write user authentication system",
    state: Task::ONGOING
  },
  {
    title: "Design database schema",
    state: Task::DONE
  },
  {
    title: "Implement task management features",
    state: Task::ONGOING
  },
  {
    title: "Add user interface components",
    state: Task::TODO
  },
  {
    title: "Write comprehensive tests",
    state: Task::TODO
  },
  {
    title: "Deploy to staging environment",
    state: Task::TODO
  },
  {
    title: "Conduct code review",
    state: Task::ONGOING
  }
]

tasks = []
tasks_data.each do |task_attrs|
  task = Task.find_or_create_by!(title: task_attrs[:title]) do |t|
    t.state = task_attrs[:state]
  end
  tasks << task
  puts "Created task: #{task.title} [#{task.state}]"
end

# Create TaskUser relationships
puts "\nCreating task assignments..."

task_assignments = [
  # Alice as creator and assignee of development environment setup
  { task: tasks[0], user: users[0], role: TaskUser::CREATOR },
  { task: tasks[0], user: users[0], role: TaskUser::ASSIGNEE },

  # Bob as creator of authentication system, Alice and Charlie as assignees
  { task: tasks[1], user: users[1], role: TaskUser::CREATOR },
  { task: tasks[1], user: users[0], role: TaskUser::ASSIGNEE },
  { task: tasks[1], user: users[2], role: TaskUser::ASSIGNEE },

  # Charlie as creator and sole assignee of database schema
  { task: tasks[2], user: users[2], role: TaskUser::CREATOR },
  { task: tasks[2], user: users[2], role: TaskUser::ASSIGNEE },

  # Diana as creator, Bob and Eve as assignees for task management features
  { task: tasks[3], user: users[3], role: TaskUser::CREATOR },
  { task: tasks[3], user: users[1], role: TaskUser::ASSIGNEE },
  { task: tasks[3], user: users[4], role: TaskUser::ASSIGNEE },

  # Eve as creator and assignee of UI components
  { task: tasks[4], user: users[4], role: TaskUser::CREATOR },
  { task: tasks[4], user: users[4], role: TaskUser::ASSIGNEE },

  # Alice as creator, Bob and Diana as assignees for tests
  { task: tasks[5], user: users[0], role: TaskUser::CREATOR },
  { task: tasks[5], user: users[1], role: TaskUser::ASSIGNEE },
  { task: tasks[5], user: users[3], role: TaskUser::ASSIGNEE },

  # Bob as creator and assignee for deployment
  { task: tasks[6], user: users[1], role: TaskUser::CREATOR },
  { task: tasks[6], user: users[1], role: TaskUser::ASSIGNEE },

  # Diana as creator, all users as assignees for code review
  { task: tasks[7], user: users[3], role: TaskUser::CREATOR },
  { task: tasks[7], user: users[0], role: TaskUser::ASSIGNEE },
  { task: tasks[7], user: users[1], role: TaskUser::ASSIGNEE },
  { task: tasks[7], user: users[2], role: TaskUser::ASSIGNEE },
  { task: tasks[7], user: users[4], role: TaskUser::ASSIGNEE }
]

task_assignments.each do |assignment|
  task_user = TaskUser.find_or_create_by!(
    task: assignment[:task],
    user: assignment[:user],
    role: assignment[:role]
  )
  puts "Assigned #{assignment[:user].pseudo} as #{assignment[:role]} to '#{assignment[:task].title}'"
end

puts "\nSeed data created successfully!"
puts "Users: #{User.count}"
puts "Tasks: #{Task.count}"
puts "Task assignments: #{TaskUser.count}"
