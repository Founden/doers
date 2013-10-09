class AddTypeToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :type, :string
  end
end
