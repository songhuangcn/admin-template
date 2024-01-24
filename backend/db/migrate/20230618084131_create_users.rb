class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: {unique: true}
      t.string :password_digest, null: false
      t.string :name, null: false
      t.integer :user_type, null: false, default: 1, comment: "用户类型(1普通用户 2管理员)"

      t.timestamps
    end
  end
end
