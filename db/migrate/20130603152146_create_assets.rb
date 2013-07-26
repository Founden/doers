class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :project
      t.references :board
      t.references :user
      t.text :description
      t.string :type
      t.integer :assetable_id
      t.string :assetable_type
      t.attachment :attachment
    end


    add_index :assets, :project_id
    add_index :assets, :board_id
    add_index :assets, :user_id
    add_index :assets, :type
    add_index :assets, [:assetable_id, :assetable_type]
  end
end
