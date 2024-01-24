require "rails_helper"

RSpec.describe Permission, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe "Validations" do
    subject { build(:permission) }

    context "when ok" do
      it "valid" do
        expect(subject.valid?).to eq(true)
      end
    end

    context "when controller blank" do
      before do
        subject.assign_attributes(controller: " ")
      end

      it "invalid" do
        expect(subject.valid?).to eq(false)
        expect(subject.errors).to have_key(:controller)
      end
    end

    context "when action blank" do
      before do
        subject.assign_attributes(action: " ")
      end

      it "invalid" do
        expect(subject.valid?).to eq(false)
        expect(subject.errors).to have_key(:action)
      end
    end
  end
end
