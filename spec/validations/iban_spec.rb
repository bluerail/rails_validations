require 'spec_helper'

module ValidationsSpecHelper
  class Iban < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Iban do
  include ValidationsSpecHelper


  it 'accepts a valid IBAN' do
    with_validation 'iban: true' do
      %w{
        NL65AEGO0721647952
        NL43ABNA0841376913
      }.each do |v|
        expect(model(v).valid?).to eq(true)
      end
    end
  end


  it 'gives an error on an invalid IBAN' do
    with_validation 'iban: true' do
      %w{
        NL65AEGO0721647951
        not valid
      }.each do |v|
        expect(model(v).valid?).to eq(false)
      end
    end
  end
end
