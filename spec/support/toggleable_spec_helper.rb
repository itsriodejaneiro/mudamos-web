require 'rspec'

RSpec.shared_examples 'a toggleable' do
  subject { FactoryGirl.build_stubbed(described_class.to_s.underscore.to_sym) }
  let(:toggleable) { FactoryGirl.create(described_class.to_s.underscore.to_sym) }
  let(:klass) {described_class.to_s.underscore.to_sym.to_s.capitalize!.constantize}


  describe "testing user and comment relations" do
    [:user, :comment].each do |model|
      before(:each) do
        @toggleable = FactoryGirl.build(described_class.to_s.underscore.to_sym)
      end

      it "should belong to #{model}" do
        should belong_to model
      end

      [nil, -1].each do |n|
        it "should validate presence of the #{model}" do
          @toggleable.send("#{model}_id=", n)
          expect { @toggleable.save }.not_to change { klass.count }
        end
      end

      it "should be valid with a correct #{model}" do
        expect { @toggleable.save }.to change { klass.count }.by(1)
      end

      unless described_class == Report
        it 'should create a Notification' do
          expect { @toggleable.save }.to change { Notification.count }.by(1)
        end

        [EmailNotification, InternalNotification, PushNotification].each do |type|
          it "should create #{type.to_s} notification" do
            expect{ @toggleable.save }.to change { type.count }.by(1)
          end
        end

      end

    end
  end

  it 'should validate uniqueness of provider' do
    toggleable.should validate_uniqueness_of(:user_id).scoped_to(:comment_id).with_message('not available')
  end

  describe 'when the unlike method is called' do
    before do
      @toggleable = FactoryGirl.create(described_class.to_s.underscore.to_sym)
    end

    it "should destroy the #{described_class.to_s.underscore.to_sym}" do
      expect { @toggleable.send("un#{described_class.to_s.underscore.to_sym.to_s}") }.to change { klass.count }.by(-1)
    end
  end

  [:id, :user_id, :comment_id, :deleted_at, :created_at,
   :updated_at, :user, :comment, "un#{described_class.to_s.underscore.to_sym.downcase}".to_sym].each do |attr|
    it "should respond to #{attr}" do
      should respond_to attr
    end
  end

end
