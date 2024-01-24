class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: "users_roles"
  has_many :roles_permissions, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def permission_names
    roles_permissions.pluck(:permission_name)
  end

  def permission_count
    roles_permissions.size
  end
end
