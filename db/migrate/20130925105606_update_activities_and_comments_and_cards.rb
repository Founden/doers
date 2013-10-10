class UpdateActivitiesAndCommentsAndCards < ActiveRecord::Migration
  def change
    add_column :activities, :comment_id, :integer
    add_index :activities, :comment_id

    remove_index :activities, [:trackable_id, :trackable_type]
    remove_column :activities, :trackable_type, :string

    rename_column :activities, :trackable_id, :card_id
    add_index :activities, :card_id

    remove_index :comments, [:commentable_id, :commentable_type]
    remove_column :comments, :commentable_type, :string

    rename_column :comments, :commentable_id, :card_id
    add_index :comments, :card_id

    remove_column :cards, :question, :string
    remove_column :cards, :help, :string

    add_column :topics, :position, :integer
    add_index :topics, :position
  end
end
