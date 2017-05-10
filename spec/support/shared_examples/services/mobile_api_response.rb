RSpec.shared_examples_for "a successfull mobile api response" do |code|
  it { expect { subject }.not_to raise_error }
end

RSpec.shared_examples_for "an error mobile api response" do |error|
  it { expect { subject }.to raise_error error }
end

