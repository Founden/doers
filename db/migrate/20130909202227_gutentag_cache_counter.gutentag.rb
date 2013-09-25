# This migration comes from gutentag (originally 2)
class GutentagCacheCounter < ActiveRecord::Migration
  def up
    add_column :tags, :taggings_count, :integer, :default => 0
    add_index  :tags, :taggings_count

    Gutentag::Tag.reset_column_information
    Gutentag::Tag.pluck(:id).each do |tag_id|
      Gutentag::Tag.reset_counters tag_id, :taggings
    end if Gutentag::Tag.table_exists?
  end

  def down
    remove_column :tags, :taggings_count
  end
end
