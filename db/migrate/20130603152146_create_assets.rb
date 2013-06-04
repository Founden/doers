class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :project, :index => true
      t.references :board, :index => true
      t.references :user, :index => true
      t.text :description
      t.string :type, :index => true
      t.integer :assetable_id, :index => true
      t.string :assetable_type, :index => true
      t.attachment :attachment
    end
  end
end
