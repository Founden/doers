class AddLoginAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :login_at, :datetime
  end
end
