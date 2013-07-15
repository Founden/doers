class AddTimestampsToCards < ActiveRecord::Migration
  def change
    add_timestamps(:cards)
  end
end
