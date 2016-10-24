RSpec.shared_examples 'friendly_id' do |attr, klass=described_class|
  describe "Friendly ID examples" do
    before(:each) do
      @model = FactoryGirl.build(klass.to_s.underscore.to_sym)
    end

    describe 'when the slug is blank' do
      before(:each) do
        @model.slug = nil
      end

      context 'and the model is saved' do
        it "should set a slug as the #{attr}" do
          expect { @model.save }.to change { @model.slug }.to(I18n.transliterate(@model.send(attr).downcase).gsub(/[^\-0-9A-Za-z\s]/, '').split(' ').join('-'))
        end
      end
    end

    describe 'when the slug is not blank' do
      before(:each) do
        @slug = @model.slug
      end

      context 'and the model is saved' do
        it "should not change the slug" do
          expect { @model.save }.not_to change { @model.slug }
        end
      end
    end
  end

end