class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email,              null: false, default: ''
      t.string :provider,           null: false, default: 'g5'
      t.string :uid,                null: false
      t.string :g5_access_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, [:provider, :uid], unique: true
  end
end
