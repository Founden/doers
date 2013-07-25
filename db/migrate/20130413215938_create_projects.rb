class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.references :user
      t.string :status
      t.string :website
      t.hstore :data
      t.string :external_id
      t.string :external_type

      t.timestamps
    end

    add_index :projects, :user_id
    add_index :projects, :website
    add_index :projects, [:external_id, :external_type]
    add_index :projects, :status
  end
end
