class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.references :board, index: true
      t.integer :position
      t.string :type
      t.text :data
    end
  end
end
