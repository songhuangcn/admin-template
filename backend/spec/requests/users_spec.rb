require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  let(:auth_user) { admin }

  describe "GET /api/users" do
    subject { get "/api/users", headers: auth_headers(auth_user) }

    context "when auth user admin" do
      before do
        create_list(:user, 10)
      end

      it "response 200" do
        subject

        expect(response).to have_http_status(200)
        expect(response.parsed_body.dig("data").size).to eq(User.count)
      end
    end

    context "when no auth" do
      let(:auth_user) { nil }

      it "response 401" do
        subject

        expect(response).to have_http_status(401)
      end
    end

    context "when auth user without permission" do
      let(:auth_user) { user }

      it "response 401" do
        subject

        expect(response).to have_http_status(403)
      end
    end

    context "when auth user with permission" do
      let(:auth_user) { user }

      before do
        roles_permission = create(:roles_permission, permission_name: "users#index")
        user.roles += [roles_permission.role]
      end

      it "response 200" do
        subject

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /api/users" do
    subject { post "/api/users", headers: auth_headers(auth_user), params: params }

    context "with role_ids" do
      let(:roles) { create_list(:role, 2) }
      let(:params) do
        {**attributes_for(:user), role_ids: roles.pluck(:id)}
      end

      it "response 200" do
        expect { subject }.to change(User, :count).by(1)
        expect(response.parsed_body["data"]).to include(
          "username" => params[:username],
          "role_names" => roles.pluck(:name)
        )
      end
    end

    context "when use admin type" do
      let(:params) do
        {**attributes_for(:user), username: "try_admin", user_type: "admin"}
      end

      let(:created_user) {
        User.find_by!(username: params[:username])
      }

      it "create normal user" do
        subject

        expect_status 200
        expect(created_user.admin?).to be(false)
      end
    end
  end

  describe "PATCH /api/users/:id" do
    subject { patch "/api/users/#{updated_user.id}", headers: auth_headers(auth_user), params: params }
    let(:updated_user) { user }

    context "with role_ids" do
      let(:new_roles) { create_list(:role, 2) }
      let(:params) do
        {name: "New Name", role_ids: new_roles.pluck(:id)}
      end

      it "response 200" do
        expect { subject }.to change { user.roles.count }.by(2)
        expect(response).to have_http_status(200)
        expect(response.parsed_body["data"]).to include(
          "name" => params[:name],
          "role_names" => new_roles.pluck(:name)
        )
      end
    end

    context "when update admin user" do
      let(:updated_user) { admin }
      let(:params) {
        {name: "New Name"}
      }

      it "response 403" do
        subject

        expect_status 403
        expect(response_message).to match(/无法操作管理员账户/)
      end
    end
  end

  describe "DELETE /api/users/:id" do
    subject { delete "/api/users/#{user.id}", headers: auth_headers(auth_user) }

    context "when ok" do
      it "response 200" do
        expect { subject }.to change(User, :count).by(-1)
        expect(User.exists?(user.id)).to eq(false)
      end
    end
  end
end
