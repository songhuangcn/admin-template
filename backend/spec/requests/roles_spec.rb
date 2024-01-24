require "rails_helper"

RSpec.describe "Roles", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:role) { create(:role) }

  let(:auth_user) { admin }

  describe "GET /api/roles" do
    subject { get "/api/roles", headers: auth_headers(auth_user) }

    context "when ok" do
      let!(:roles) { create_list(:role, 10) }

      it "response 200" do
        subject

        expect(response).to have_http_status(200)
        expect(response.parsed_body.dig("data").size).to eq(Role.count)
      end
    end
  end

  describe "POST /api/roles" do
    subject { post "/api/roles", headers: auth_headers(auth_user), params: params }

    context "with permission_names" do
      let(:params) do
        {name: "Role Name", permission_names: ["users#index", "roles#index"]}
      end

      it "response 200" do
        expect { subject }
          .to change(Role, :count).by(1)
          .and change(RolesPermission, :count).by(2)
        expect(response.parsed_body["data"]).to include(
          "name" => params[:name],
          "permission_names" => params[:permission_names]
        )
      end
    end
  end

  describe "PATCH /api/roles/:id" do
    subject { patch "/api/roles/#{role.id}", headers: auth_headers(auth_user), params: params }

    context "with role_ids" do
      let(:params) do
        {name: "New Name", permission_names: ["new_controller#new_action"]}
      end

      it "response 200" do
        expect { subject }.to change(RolesPermission, :count).by(1)
        expect(response).to have_http_status(200)
        expect(response.parsed_body["data"]).to include(
          "name" => params[:name],
          "permission_names" => params[:permission_names]
        )
      end
    end
  end

  describe "DELETE /api/roles/:id" do
    subject { delete "/api/roles/#{role.id}", headers: auth_headers(auth_user) }

    context "when ok" do
      it "response 200" do
        expect { subject }.to change(Role, :count).by(-1)
        expect(User.exists?(role.id)).to eq(false)
      end
    end
  end
end
