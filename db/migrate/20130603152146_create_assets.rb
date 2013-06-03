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
      t.string :attachment_file_name
      t.string :attachment_remote_url
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
    end
  end
end
