class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :ideas
      t.string :notes
      t.string :start_by
      t.string :finish_by
      t.integer :user_id
      t.integer :category_id
    end
  end
end
