RSpec.shared_examples 'paranoia' do |klass=described_class|
  describe "Paranoia Examples" do
    before(:each) do
      @model = FactoryGirl.create(klass.to_s.underscore.to_sym)
    end

    # DELETED SCOPED
    describe "#{klass.to_s}" do
      [:with_deleted, :only_deleted].each do |s|
        it "should respond to the #{s} scope" do
          expect(described_class).to respond_to(s)
        end
      end
    end

    # TESTING THE DESTROY ACTION
    describe "when the model is deleted" do
      before(:each) do
        @id = @model.id
        @model.destroy
      end

      it "should set the deleted_at attribute" do
        expect(@model.deleted_at).not_to be_nil
      end

      it "should not be found on the default scope" do
        expect { described_class.find(@id) }.to raise_error { ActiveRecord::RecordNotFound }
      end

      [:unscoped, :with_deleted, :only_deleted].each do |s|
        it "should be found on the unscoped" do
          expect { described_class.send(s).find(@id) }.not_to raise_error { ActiveRecord::RecordNotFound }
        end
      end

      context "and is restored after that" do
        before(:each) do
          @model.restore
        end

        it "should set the deleted_at attribute to nil" do
          expect(@model.deleted_at).to be_nil
        end

        it "should be found on the default scope" do
          expect { described_class.find(@id) }.not_to raise_error { ActiveRecord::RecordNotFound }
        end

        [:unscoped, :with_deleted].each do |s|
          it "should be found on the #{s} scope" do
            expect { described_class.send(s).find(@id) }.not_to raise_error { ActiveRecord::RecordNotFound }
          end
        end

        it "should not be found on the only_deleted scope" do
          expect { described_class.only_deleted.find(@id) }.to raise_error { ActiveRecord::RecordNotFound }
        end
      end
    end
  end

end