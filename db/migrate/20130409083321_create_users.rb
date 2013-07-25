class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.hstore :data
      t.string :external_id
      t.string :external_type

      t.timestamps
    end

    add_index :users, :email
    add_index :users, [:external_id, :external_type]
  end
end
