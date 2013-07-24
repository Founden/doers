class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.references :user, index: true
      t.string :status
      t.hstore :data

      t.timestamps
    end
  end
end
