require 'spec_helper'

module ValidationsSpecHelper
  class Date < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Date do
  include ValidationsSpecHelper

  it_behaves_like :validation, 'date'

  it 'works with true' do
    with_validation 'date: true' do
      expect(model(Date.today)).to be_valid
      expect(model(Time.now)).to be_valid
    end
  end


  it 'works with :after' do
    with_validation 'date: { after: ::Date.today }' do
      expect(model(Date.today.advance days: 1)).to be_valid
      expect(model(Date.today)).to be_invalid('date.after', date: Date.today)
      expect(model(Date.today.advance days: -1)).to be_invalid('date.after', date: Date.today)
    end
  end


  it 'works with :after_or_equal_to:' do
    with_validation 'date: { after_or_equal_to: ::Date.today }' do
      expect(model(Date.today)).to be_valid
      expect(model(Date.today.advance days: 1)).to be_valid
      expect(model(Date.today.advance days: -1)).to be_invalid('date.after_or_equal_to', date: Date.today)
    end
  end


  it 'works with :equal_to' do
    with_validation 'date: { equal_to: ::Date.today }' do
      expect(model(Date.today)).to be_valid
      expect(model(Date.today.advance days: 1)).to be_invalid('date.equal_to', date: Date.today)
      expect(model(Date.today.advance days: -1)).to be_invalid('date.equal_to', date: Date.today)
    end
  end


  it 'works with :before' do
    with_validation 'date: { before: ::Date.today }' do
      expect(model(Date.today.advance days: -1)).to be_valid
      expect(model(Date.today)).to be_invalid('date.before', date: Date.today)
      expect(model(Date.today.advance days: 1)).to be_invalid('date.before', date: Date.today)
    end
  end


  it 'works with :before_or_equal_to' do
    with_validation 'date: { before_or_equal_to: ::Date.today }' do
      expect(model(Date.today)).to be_valid
      expect(model(Date.today.advance days: -1)).to be_valid
      expect(model(Date.today.advance days: 1)).to be_invalid('date.before_or_equal_to', date: Date.today)
    end
  end


  it "works with input that is not even remotely a date" do
    with_validation 'date: true' do
      expect(model('Yesterday, a fish nibbled my toe.')).to be_invalid('date.invalid')
    end
  end


  it 'works when comparing to another column' do
    with_validation 'date: { after: :v2 }' do
      expect(model(Date.today, Date.today - 2.days)).to be_valid
      expect(model(Date.today.to_s, (Date.today - 2.days).to_s)).to be_valid
    end
  end

  it 'works when giving a string' do
    with_validation 'date: true' do
      [
        '2015-01-01',
        '01-09-2015',
      ].each do |str|
        expect(model(str)).to be_valid
      end
    end
  end

  it "sets an errors when a string isn't quite a valid date" do
    with_validation 'date: true' do
      [
        '6-2015',
      ].each do |str|
        expect(model(str)).to be_invalid('date.invalid')
      end
    end
  end
end
