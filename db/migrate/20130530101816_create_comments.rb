class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :parent_comment, index: true
      t.references :project, index: true
      t.references :board, index: true
      t.references :user, index: true
      t.text :content

      t.timestamps
    end
  end
end
