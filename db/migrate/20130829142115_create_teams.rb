class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :title
      t.string :description
      t.string :slug
      t.hstore :data

      t.timestamps
    end

    add_index :teams, :slug, :unique => true

    add_column :boards, :team_id, :integer
    add_index :boards, :team_id
  end
end
