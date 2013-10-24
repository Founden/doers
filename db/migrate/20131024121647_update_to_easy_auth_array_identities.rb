class UpdateToEasyAuthArrayIdentities < ActiveRecord::Migration
  def change
    rename_column :identities, :uid, :old_uid
    add_column :identities, :uid, :string, array: true, default: []
    add_index :identities, :uid, using: 'gin'

    Identity.all.each do |ident|
      ident.uid = [ident.old_uid]
      ident.save
    end

    remove_column :identities, :old_uid
  end
end
