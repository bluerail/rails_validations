require 'spec_helper'

module ValidationsSpecHelper
  class Email < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Email do
  include ValidationsSpecHelper

  it_behaves_like :validation, 'email'

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
        expect(model(v)).to be_invalid('email.invalid')
      end

      # Newlines in email addresses is a potential security problem, do double
      # check this
      expect(model("no\nnewlines@example.com")).to be_invalid('email.invalid')
      expect(model("no\rnewlines@example.com")).to be_invalid('email.invalid')
      expect(model("no\r\nnewlines@example.com")).to be_invalid('email.invalid')
    end
  end


  it 'works for valid emails' do
    with_validation 'email: true' do
      %w{
        valid@example.com
        valid.address@example.com
        valid-example@example.com
        valid+address@example.com
        valid@more.than.one.example.com
        valid@example.anewtld
        مفتوح.ذبابة@إرهاب.شبكة
      }.each do |v|
        expect(model(v)).to be_valid
      end
    end
  end
end
