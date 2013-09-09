class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :email
      t.references :user
      t.references :membership, :polymorphic => true
      t.references :invitable, :polymorphic => true
      t.hstore :data

      t.timestamps
    end

    add_index :invitations, :email, :unique => true
    add_index :invitations, :user_id
    add_index :invitations, [:membership_id, :membership_type]
    add_index :invitations, [:invitable_id, :invitable_type]
  end
end
