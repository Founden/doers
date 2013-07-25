class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :parent_comment
      t.references :project
      t.references :board
      t.references :user
      t.text :content
      t.hstore :data

      t.timestamps
    end

    add_index :comments, :parent_comment_id
    add_index :comments, :project_id
    add_index :comments, :board_id
    add_index :comments, :user_id
  end
end
