require "rails_helper"

RSpec.describe "Sessions", type: :request do
  using RSpec::Parameterized::TableSyntax

  let!(:user) { create(:user, username: username, password: password) }
  let!(:username) { "username" }
  let!(:password) { "password" }

  describe "POST /api/login" do
    subject { post "/api/login", params: params }

    let(:params) { {username: login_username, password: login_password} }

    context "with login params" do
      where(:login_username, :login_password, :expected_status) do
        ref(:username) | ref(:password) | 200
        "wrong-username" | ref(:password) | 401
        ref(:username) | "wrong-password" | 401
      end

      with_them do
        it "response correct" do
          subject

          expect(response).to have_http_status(expected_status)
        end
      end
    end
  end

  describe "GET /api/user" do
    subject { get "/api/user", headers: auth_headers(user) }

    it "response 200" do
      subject

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to include(
        "meta",
        "data" => a_hash_including(
          "username",
          "admin",
          "role_names",
          "permission_names",
          "id" => user.id
        )
      )
    end
  end
end
