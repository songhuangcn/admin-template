FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username-#{n}" }
    name { "Name" }
    password { "password" }

    transient do
      todos_count { 0 }
      todos_state { :pending }
      molds_count { 0 }
    end

    after(:create) do |user, evaluator|
      if evaluator.todos_count > 0
        project = create(:project, manager: user)
        mold = create(:mold, project: project)
        create_list(:todo, evaluator.todos_count, mold: mold, state: evaluator.todos_state)
      elsif evaluator.molds_count > 0
        project = create(:project, manager: user)
        create_list(:mold, evaluator.molds_count, project: project)
      end
    end
  end
end
