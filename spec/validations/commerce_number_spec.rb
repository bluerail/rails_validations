require 'spec_helper'

module ValidationsSpecHelper
  class CommerceNumber < ValidationsSpecHelper::Record
  end
end

describe ValidationsSpecHelper::CommerceNumber do
  include ValidationsSpecHelper
  
  it_behaves_like :validation, 'commerce_number'
  it_behaves_like :country_code, 'commerce_number'

  it 'works for nl codes' do
    with_validation 'commerce_number: { country: :nl }' do
      [
        12345678,
        '12345678',
        :'12345678',
        '123 45-6.78',
      ].each do |v|
        expect(model(v)).to be_valid
      end
    end
  end


  it 'gives an error for nl codes' do
    with_validation 'commerce_number: { country: :nl }' do
      %w{
        whoops
        1234567
        123456789
      }.each do |v|
        expect(model(v)).to be_invalid('commerce_number.invalid')
      end
    end
  end
end
