require 'spec_helper'

module ValidationsSpecHelper
  class ValidationsSpecHelper::Domain < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Domain do
  include ValidationsSpecHelper

  it 'gives an error on invalid domains' do
    with_validation 'domain: true' do
      %w{
      li\ co.nl
      li_co.nl
      lico@nl
      }.each do |v|
        expect(model(v).valid?).to eq(false)
      end
    end
  end


  it 'works for valid domains' do
    with_validation 'domain: true' do
      %w{
      lico
      lico.nl
      www.lico.nl
      hello.world.www.lico.nl
      ﻢﻔﺗﻮﺣ.ﺬﺑﺎﺑﺓ
      }.each do |v|
        expect(model(v).valid?).to eq(true)
      end
    end
  end

  
  it 'works with :max_domain_parts' do
    with_validation 'domain: { max_domain_parts: 3 }' do
      expect(model('not.many').valid?).to eq(true)
      expect(model('not.too.many').valid?).to eq(true)
      expect(model('too.many.domain.parts').valid?).to eq(false)
    end
  end


  it 'works with :min' do
    with_validation 'domain: { min_domain_parts: 3 }' do
      expect(model('too.few').valid?).to eq(false)
      expect(model('just.enough.parts').valid?).to eq(true)
      expect(model('more.than.enough.parts').valid?).to eq(true)
    end
  end
end
