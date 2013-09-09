class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :slug
      t.belongs_to :user
      t.belongs_to :project
      t.belongs_to :board
      t.belongs_to :trackable, :polymorphic => true
      t.hstore :data

      t.timestamps
    end

    add_index :activities, :user_id
    add_index :activities, :project_id
    add_index :activities, :board_id
    add_index :activities, [:trackable_id, :trackable_type]
    add_index :activities, :slug
  end
end
