class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.text :description
      t.references :user
      t.references :author
      t.references :project
      t.references :parent_board
      t.string :status

      t.timestamps
    end

    add_index :boards, :parent_board_id
    add_index :boards, :project_id
    add_index :boards, :user_id
    add_index :boards, :author_id
    add_index :boards, :status
  end
end
