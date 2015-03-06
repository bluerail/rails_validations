require 'spec_helper'

module ValidationsSpecHelper
  class PostalCode < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::PostalCode do
  include ValidationsSpecHelper

  it_behaves_like :validation, 'postal_code'

  it 'works for nl codes' do
    with_validation 'postal_code: { country: :nl }' do
      %w{
        5600aa
        1000Aa
        9999\ aa
        1234\ AA
      }.each do |v|
        expect(model(v)).to be_valid
      end
    end
  end


  it 'gives an error for nl codes' do
    with_validation 'postal_code: { country: :nl }' do
      %w{
        560aa
        10000Aa
        9999\ a
        1234\ AAA
      }.each do |v|
        expect(model(v)).to be_invalid('postal_code.invalid')
      end
    end
  end
end
