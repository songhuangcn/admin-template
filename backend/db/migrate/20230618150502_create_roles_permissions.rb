class CreateRolesPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :roles_permissions do |t|
      t.bigint :role_id, null: false, index: true
      t.string :permission_name, null: false, index: true

      t.timestamps
    end
  end
end
