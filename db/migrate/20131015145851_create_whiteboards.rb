class CreateWhiteboards < ActiveRecord::Migration
  def change
    create_table :whiteboards do |t|
      t.string :title
      t.text :description
      t.references :user, index: true
      t.references :team, index: true

      t.timestamps
    end

    remove_column :boards, :author_id
    remove_column :boards, :parent_board_id

    add_column :comments, :whiteboard_id, :integer
    add_index :comments, :whiteboard_id

    add_column :activities, :whiteboard_id, :integer
    add_index :activities, :whiteboard_id

    add_column :boards, :whiteboard_id, :integer
    add_index :boards, :whiteboard_id

    add_column :topics, :whiteboard_id, :integer
    add_index :topics, :whiteboard_id

    add_column :assets, :whiteboard_id, :integer
    add_index :assets, :whiteboard_id

    # Some cards cleanup
    add_column :cards, :alignment, :bool
    add_index :cards, :alignment

    remove_column :cards, :parent_card_id
  end
end
