class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title
      t.string :description
      t.references :user, index: true
      t.references :author, index: true
      t.references :project, index: true
      t.references :parent_board, index: true
      t.string :status

      t.timestamps
    end
  end
end
