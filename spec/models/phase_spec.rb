# == Schema Information
#
# Table name: phases
#
#  id                   :integer          not null, primary key
#  cycle_id             :integer
#  name                 :string
#  description          :string
#  tooltip              :string
#  initial_date         :datetime
#  final_date           :datetime
#  slug                 :string
#  deleted_at           :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  picture_file_name    :string
#  picture_content_type :string
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

require 'rails_helper'

RSpec.describe Phase, type: :model do
  subject { FactoryGirl.build_stubbed(:phase) }
  let(:phase) { FactoryGirl.build(:phase) }

  include_examples 'friendly_id', :name
  include_examples 'paranoia'

  [:name, :description, :tooltip, :initial_date, :final_date, :cycle].each do |attr|
    it "should validate #{attr}" do
      should validate_presence_of attr
    end
  end

  it 'Should have attached picture' do
    should have_attached_file(:picture)
  end

  # Testing dates
  describe "when the final_date is" do
    subject{FactoryGirl.build(:phase, initial_date: Time.zone.now.beginning_of_day, final_date: Time.zone.now.beginning_of_day )}
    context "before initial_date" do
      (-100..-1).each do |n|
        it "should not be valid" do
          should_not allow_value(n.days.from_now).for(:final_date)
        end
      end
    end

    context "the same day as initial_date" do
      it "should not be valid" do
        should allow_value(Time.zone.now.beginning_of_day).for(:final_date)
      end
    end

    context "after initial_date" do
      (2..100).each do |n| #number 2 because the difference between fuses
        it "should be valid for final_date as #{n.days.from_now.to_date}" do
          should allow_value(n.days.from_now).for(:final_date)
        end
      end
    end
  end


  # RELATIONS
  it 'should belong to cycle' do
    should belong_to :cycle
  end

  it 'should have many permissions' do
    should have_many :permissions
  end

  it 'should have many permissions' do
    should have_one :plugin_relation
  end

  it "should have many plugins through plugin_relations" do
    should delegate_method(:plugin).to(:plugin_relation)
  end

  # Status
  it 'should have a statuses method' do
    Phase.should respond_to :statuses
  end

  it 'should have a statuses method that responds the possible statuses' do
    expect(Phase.statuses).to eq([:finished, :in_progress, :shortly])
  end

  Phase.statuses.each do |status|
    it 'should respond_to the #{status} scopes' do
      Phase.should respond_to("#{status}".to_sym)
    end
  end

  Phase.statuses.each do |status|
    it "should repond_to #{status}? method" do
      should respond_to("#{status}?".to_sym)
    end
  end

  describe "with statuses" do
    before(:each) do
      Phase.statuses.each do |status|
        2.times do
          FactoryGirl.create("#{status}_phase".to_sym)
        end
      end
    end

    {
      in_progress: Phase.where{ (initial_date <= Time.zone.now) & (final_date >= Time.zone.now) },
      finished: Phase.where{ final_date < Time.zone.now },
      shortly: Phase.where{ initial_date > Time.zone.now }
    }.each do |k, v|
      describe "the #{k} scope" do
        before(:each) do
          @collection = Phase.send(k)
        end

        it 'should return the correct items' do
          expect(@collection.pluck(:id)).to eq(v.pluck(:id))
        end

        Phase.statuses.each do |status|
          expected = (status == k ? true : false)

          it "the #{status}? method should return #{expected}" do
            expect(@collection.map { |x| x.send("#{status}?".to_sym) }.uniq).to eq([expected])
          end
        end
      end
    end
  end

  {
    in_progress: 'Em andamento',
    shortly: 'Em breve',
    finished: 'Encerrado'
  }.each do |k, v|
    describe "a phase with #{k} status" do
      before(:each) do
        @resource = FactoryGirl.create("#{k}_phase")
      end

      it "should return the #{v} current_status" do
        expect(@resource.current_status).to eq(v)
      end
    end
  end

  Phase.statuses.each do |status|
    
  end

end
