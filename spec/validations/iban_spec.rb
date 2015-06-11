require 'spec_helper'

module ValidationsSpecHelper
  class Iban < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Iban do
  include ValidationsSpecHelper

  it_behaves_like :validation, 'iban'

  it 'accepts a valid IBAN' do
    with_validation 'iban: true' do
      %w{
        NL65AEGO0721647952
        NL43ABNA0841376913
        NL08RABO0134155858
      }.each do |v|
        expect(model(v)).to be_valid
      end
    end
  end


  it 'gives an error on an invalid IBAN' do
    with_validation 'iban: true' do
      %w{
        NL65AEGO0721647951
        not valid
      }.each do |v|
        expect(model(v)).to be_invalid('iban.invalid')
      end
    end
  end


  it 'sets detailed errrors' do
    with_validation 'iban: { detailed_errors: true }' do
      m = model 'NL61AEGO0721647952'
      expect(m.valid?).to eq(false)
      expect(m.errors.first[1]).to eq(I18n.t('rails_validations.iban.bad_check_digits'))
    end
  end
end
