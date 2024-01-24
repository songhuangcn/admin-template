FactoryBot.define do
  factory :roles_permission do
    association :role
    sequence(:permission_name) { |n| "controller-#{n}#action-#{n}" }
  end
end
