class CreateTaskUserTable < ActiveRecord::Migration[8.0]
  def change
    create_table :task_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.string :role, null: false
      t.timestamps
    end

    add_index :task_users, [ :user_id, :task_id ], unique: true
    add_index :task_users, :role
  end
end
