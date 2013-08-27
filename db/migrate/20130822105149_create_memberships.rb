class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :creator, index: true
      t.references :user, index: true
      t.references :project, index: true
      t.references :board, index: true
      t.string :type
      t.hstore :data

      t.timestamps
    end
  end
end
