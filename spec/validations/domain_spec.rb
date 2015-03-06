require 'spec_helper'

module ValidationsSpecHelper
  class ValidationsSpecHelper::Domain < ValidationsSpecHelper::Record
  end
end


describe ValidationsSpecHelper::Domain do
  include ValidationsSpecHelper

  it_behaves_like :validation, 'domain'

  it 'gives an error on invalid domains' do
    with_validation 'domain: true' do
      %w{
      li\ co.nl
      li_co.nl
      lico@nl
      }.each do |v|
        expect(model(v)).to be_invalid('domain.invalid')
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
        expect(model(v)).to be_valid
      end
    end
  end

  
  it 'works with :max_domain_parts' do
    with_validation 'domain: { max_domain_parts: 3 }' do
      expect(model('not.many')).to be_valid
      expect(model('not.too.many')).to be_valid
      expect(model('too.many.domain.parts')).to be_invalid('domain.max_domain_parts', max: 3)
    end
  end


  it 'works with :min' do
    with_validation 'domain: { min_domain_parts: 3 }' do
      expect(model('just.enough.parts')).to be_valid
      expect(model('more.than.enough.parts')).to be_valid
      expect(model('too.few')).to be_invalid('domain.min_domain_parts', min: 3)
    end
  end
end
