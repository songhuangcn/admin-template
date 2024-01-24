class CreateUsersRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :users_roles do |t|
      t.bigint :user_id, null: false, index: true
      t.bigint :role_id, null: false, index: true

      t.timestamps
    end
  end
end
