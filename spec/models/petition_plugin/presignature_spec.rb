# == Schema Information
#
# Table name: petition_plugin_presignatures
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  plugin_relation_id :integer          not null
#  deleted_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require "rails_helper"

RSpec.describe PetitionPlugin::Presignature do
  subject { described_class.new }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :plugin_relation }

  describe "validations" do
    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :plugin_relation }

    context "#plugin_type_petition" do
      let(:cycle) { create_cycle_with_phase phases: [{plugin_type: :petition }] }
      let(:plugin_relation) { cycle.plugin_relations.first }

      subject { described_class.new plugin_relation: plugin_relation }

      it { is_expected.to have(:no).errors_on(:plugin_relation) }

      context "with an invalid plugin" do
        let(:cycle) { create_cycle_with_phase phases: [{plugin_type: :report }] }
        it { is_expected.to have_at_least(1).errors_on(:plugin_relation) }
      end
    end

    context "user uniqueness" do
      let!(:one_signature) { FactoryGirl.create :petition_plugin_presignature }
      let(:another_signature) { FactoryGirl.build :petition_plugin_presignature, plugin_relation: one_signature.plugin_relation }

      it { is_expected.to validate_uniqueness_of(:user).scoped_to :plugin_relation_id }
    end
  end
end
