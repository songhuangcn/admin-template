class User < ApplicationRecord
  has_secure_password

  has_and_belongs_to_many :roles, join_table: "users_roles"
  has_many :roles_permissions, through: :roles

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, if: :new_record?
  validates :name, presence: true

  enum user_type: {
    normal_user: 1,
    admin: 2
  }, _default: :normal_user

  scope :by_user_type, ->(user_type) { where(user_type: user_type) if user_type.present? }

  class << self
    def valid_user_types
      user_types.except(:admin)
    end
  end

  def role_names
    roles.pluck(:name)
  end

  def permission_names
    roles_permissions.distinct.pluck(:permission_name)
  end

  def permissions
    Permission.where(name: permission_names)
  end

  alias_method :admin, :admin?
end
