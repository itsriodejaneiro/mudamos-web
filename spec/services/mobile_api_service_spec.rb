require "rails_helper"

RSpec.describe MobileApiService do

  describe "#remove_account" do
    let(:email) { "le@email" }
    let(:response) do
      { status: "success" }
    end

    let(:connection) do
      Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.post("/api/v1/users/remove/account", JSON.dump(user: { email: email })) do |env|
            [200, {}, JSON.dump(response)]
          end
        end
      end
    end

    let(:service) { described_class.new }

    before do
      service.connection = connection
    end

    subject { service.remove_account email: email }

    it_behaves_like "a successfull mobile api response"

    context "when validation error" do
      let(:response) do
        { status: "fail", data: { errorCode: 666 } }
      end

      it_behaves_like "an error mobile api response", MobileApiService::ValidationError
    end

    context "when invalid request" do
      let(:response) do
        { status: "error" }
      end

      it_behaves_like "an error mobile api response", MobileApiService::InvalidRequest
    end
  end
end
