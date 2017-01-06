require "rails_helper"

RSpec.describe Api::V2::PlipsController do
  describe "GET index" do
    let!(:cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition, with_petition_information: true }]}
    let(:make_request) { get :index }

    it_behaves_like "a successfull api response", 200 do
      before { make_request }
    end

    describe "pagination headers" do
      subject do
        make_request
        response.headers
      end

      its(["X-Page"]) { is_expected.to eq "1" }
      it { is_expected.to_not have_key "X-Next-Page" }

      context "with more plips" do
        let!(:another_cycle) { create_cycle_with_phase phases: [{ plugin_type: :petition, with_petition_information: true }]}

        its(["X-Next-Page"]) { is_expected.to eq "2" }
      end
    end

    describe "response#body" do
      subject(:json) do
        make_request
        JSON.parse(response.body, symbolize_names: true)[:data][:plips]
      end

      it { is_expected.to have(1).plip }

      describe "#first" do
        subject(:plip_response) { json.first }

        it_behaves_like "a plip response" do
          let(:phase) { cycle.phases.first }
        end
      end
    end
  end
end
