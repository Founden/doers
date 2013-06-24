class AddDataToComments < ActiveRecord::Migration
  def change
    add_column :comments, :data, :string
  end
end
