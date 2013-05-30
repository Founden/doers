class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :data

      t.timestamps
    end

    add_index :users, :email
  end
end
