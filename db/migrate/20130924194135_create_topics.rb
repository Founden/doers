class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.text :description
      t.references :user
      t.references :project
      t.references :board
      t.hstore :data

      t.timestamps
    end

    add_index :topics, :user_id
    add_index :topics, :project_id
    add_index :topics, :board_id

    add_column :cards, :topic_id, :integer
    add_column :comments, :topic_id, :integer
    add_column :activities, :topic_id, :integer

    add_index :cards, :topic_id
    add_index :comments, :topic_id
    add_index :activities, :topic_id
  end
end
