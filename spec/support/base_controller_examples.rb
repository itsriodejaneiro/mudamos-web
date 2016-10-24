RSpec.shared_examples 'base_controller' do |route, excepts, header = nil|
  header ||= {
    :'Content-Type' => 'application/json',
    :'Accept' => 'application/json',
    :'X-PLATFORM' => 'web'
  }
  excepts.each do |exception|
    context "when calling #{route}" do
      context "without #{exception} header" do
        before(:each){post route,{}, header.except(exception.to_sym)}
        it 'should return a JSON response' do
          expect(response.content_type).to eq("application/json")
        end

        it 'should return a 422 response status'do
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
