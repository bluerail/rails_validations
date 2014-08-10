require 'spec_helper'
require 'active_support/core_ext/date/calculations'

module ValidationsSpecHelper
  class Date < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Date do
  include ValidationsSpecHelper


  it 'works with true' do
    with_validation 'date: true' do
      expect(model(Date.today).valid?).to eq(true)
      expect(model(Time.now).valid?).to eq(true)

    end
  end


  it 'works with :after' do
    with_validation 'date: { after: ::Date.today }' do
      expect(model(Date.today).valid?).to eq(false)
      expect(model(Date.today.advance days: 1).valid?).to eq(true)
      expect(model(Date.today.advance days: -1).valid?).to eq(false)
    end
  end


  it 'works with :after_or_equal_to:' do
    with_validation 'date: { after_or_equal_to: ::Date.today }' do
      expect(model(Date.today).valid?).to eq(true)
      expect(model(Date.today.advance days: 1).valid?).to eq(true)
      expect(model(Date.today.advance days: -1).valid?).to eq(false)
    end
  end


  it 'works with :equal_to' do
    with_validation 'date: { equal_to: ::Date.today }' do
      expect(model(Date.today).valid?).to eq(true)
      expect(model(Date.today.advance days: 1).valid?).to eq(false)
      expect(model(Date.today.advance days: -1).valid?).to eq(false)
    end
  end


  it 'works with :before' do
    with_validation 'date: { before: ::Date.today }' do
      expect(model(Date.today).valid?).to eq(false)
      expect(model(Date.today.advance days: 1).valid?).to eq(false)
      expect(model(Date.today.advance days: -1).valid?).to eq(true)
    end
  end


  it 'works with :before_or_equal_to' do
    with_validation 'date: { before_or_equal_to: ::Date.today }' do
      expect(model(Date.today).valid?).to eq(true)
      expect(model(Date.today.advance days: 1).valid?).to eq(false)
      expect(model(Date.today.advance days: -1).valid?).to eq(true)
    end
  end
end
