class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :external_id, :limit => 8
      t.string :name
      t.string :email
      t.hstore :data

      t.timestamps
    end

    add_index :users, :email
  end
end
