class AddCardVersions < ActiveRecord::Migration
  def change
    add_column :cards, :parent_card_id, :integer
  end
end
