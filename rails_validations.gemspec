$:.push File.expand_path('../lib', __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_validations'
  s.version     = '2.3'
  s.authors     = ['Bluerail']
  s.email       = ['info@bluerail.nl']
  s.homepage    = 'https://github.com/bluerail/rails_validations'
  s.summary     = 'Extra validations for rails'
  s.description = 'Extra validations for rails: date, domain, email, iban, phone, postal_code, commerce_number, vat_number'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.markdown']
  s.test_files = Dir['spec/**/*']

  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'actionpack', '>= 4.2.8'
  s.add_dependency 'activerecord', '>= 4.0'
  s.add_development_dependency 'rspec-rails', '>= 3.6'
  s.add_development_dependency 'iban-tools', '~> 1.0'
end
