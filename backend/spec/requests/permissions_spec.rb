require "rails_helper"

RSpec.describe "Permissions", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  let(:auth_user) { admin }

  describe "GET /api/permissions" do
    subject { get "/api/permissions", headers: auth_headers(auth_user) }

    context "when ok" do
      it "response 200" do
        subject

        expect(response).to have_http_status(200)
        data = response.parsed_body.dig("data")
        data.each { |item| expect(item).to include("name", "name_i18n") }
      end
    end
  end
end
