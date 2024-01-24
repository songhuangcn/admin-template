require "rails_helper"

RSpec.describe RolesPermission, type: :model do
  describe "Validations" do
    subject { build(:roles_permission, role: role) }

    let!(:role) { create(:role) }

    context "when ok" do
      it "valid" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when permission_name repeat" do
      before do
        create(:roles_permission, role: role, permission_name: subject.permission_name)
      end

      it "invalid" do
        subject.validate

        expect(subject.errors.key?(:permission_name)).to eq(true)
      end
    end
  end
end
