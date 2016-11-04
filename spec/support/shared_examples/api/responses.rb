RSpec.shared_examples_for "a successfull api response" do |code|
  it { expect(response).to be_success }

  if code.present?
    it %(responds with the "#{code}" status code) do
      expect(response.code).to eq code.to_s
    end
  end

  describe "response#body" do
    subject { JSON.parse response.body, symbolize_names: true }

    its([:status]) { is_expected.to eq "success" }
    it { is_expected.to have_key :data }
  end
end

RSpec.shared_examples_for "an error api response" do |code|
  it { expect(response).to_not be_success }

  if code.present?
    it %(responds with the "#{code}" status code) do
      expect(response.code).to eq code.to_s
    end
  end
end
