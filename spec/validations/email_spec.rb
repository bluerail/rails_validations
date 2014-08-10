require 'spec_helper'

module ValidationsSpecHelper
  class Email < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Email do
  include ValidationsSpecHelper


  it 'gives an error on invalid emails' do
    with_validation 'email: true' do
      %w{
        not\ valid
        invalid@example.
        invalid@@example.com
        invalid@example..com
        @example.com
        invalid@.com
        invalid@example.c
        in\ valid@example.com
        invalid@exam\ ple.com
      }.each do |v|
        expect(model(v).valid?).to eq(false)
      end
    end
  end


  it 'works for valid emails' do
    with_validation 'email: true' do
      %w{
        valid@example.com
        valid.address@example.com
        valid-example@example.com
        valid+address@example.com
        valid@example.anewtld
        مفتوح.ذبابة@إرهاب.شبكة
      }.each do |v|
        expect(model(v).valid?).to eq(true)
      end
    end
  end


  it 'accepts a custom error message' do
    with_validation 'email: { message: "foobar" }' do
      m = described_class.new v: 'not even remotely valid'
      m.valid?
      expect(m.errors[:v].first).to eq('foobar')
    end
  end
end
