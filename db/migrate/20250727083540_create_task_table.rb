class CreateTaskTable < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.string :state, null: false
      t.timestamps
    end

    add_index :tasks, :state
  end
end
