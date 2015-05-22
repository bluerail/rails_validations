require 'spec_helper'

module ValidationsSpecHelper
  class VatNumber < ValidationsSpecHelper::Record
  end
end

describe ValidationsSpecHelper::VatNumber do
  include ValidationsSpecHelper
  
  it_behaves_like :validation, 'vat_number'
  it_behaves_like :country_code, 'vat_number'

  it 'works for nl codes' do
    with_validation 'vat_number: { country: :nl }' do
      %w{
        NL123456789B00
        NL123456789B99
        NL.00-00\ 01\ 34-0B.57
        nl123456789b00
      }.each do |v|
        expect(model(v)).to be_valid
      end
    end
  end


  it 'gives an error for nl codes' do
    with_validation 'vat_number: { country: :nl }' do
      %w{
        NL123456789A00
        NL123456789B9
        NL23456789B99
        NL1234567890B99
        NLL1234567890B99
      }.each do |v|
        expect(model(v)).to be_invalid('vat_number.invalid')
      end
    end
  end
end
