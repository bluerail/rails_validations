require 'spec_helper'

module ValidationsSpecHelper
  class Phone < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Phone do
  include ValidationsSpecHelper
  
  it_behaves_like :validation, 'phone'

  it 'allows valid phone numbers' do
    with_validation 'phone: true' do
      %w{
        06\ 5155\ 2300
        +031\ 06\ 5155\ 2300
        +31\ 06\ 5155\ 2300
        (+31)\ 06-51552300
        (+1)\ 06.51.55.23.00
      }.each do |v|
        expect(model(v)).to be_valid
      end
    end
  end


  it 'gives an error on invalid phone numbers' do
    with_validation 'phone: true' do
      %w{
      06-abc
      {06}51559000
      123123*123123
      123
      132131313213213123123213213131231242312554
      }.each do |v|
        expect(model(v)).to be_invalid('phone.invalid')
      end
    end
  end
end
