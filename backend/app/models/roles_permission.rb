class RolesPermission < ApplicationRecord
  belongs_to :role

  validates :role_id, presence: true
  validates :permission_name, presence: true, uniqueness: {scope: :role_id}

  def permission
    Permission.find_by(name: permission_name)
  end
end
