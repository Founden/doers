class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :user
      t.references :project
      t.references :board
      t.integer :position
      t.string :title
      t.string :type
      t.text :content
      t.hstore :data

      t.timestamps
    end

    add_index :cards, :user_id
    add_index :cards, :project_id
    add_index :cards, :board_id
    add_index :cards, :position
    add_index :cards, :type
  end
end
