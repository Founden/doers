class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.string :label
      t.integer :position
      t.references :user, index: true
      t.string :status

      t.timestamps
    end
  end
end
