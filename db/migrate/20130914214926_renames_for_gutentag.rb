class RenamesForGutentag < ActiveRecord::Migration
  def change
    rename_table :tags,     :gutentag_tags
    rename_table :taggings, :gutentag_taggings
  end
end
