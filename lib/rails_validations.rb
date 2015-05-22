require 'validators/commerce_number_validator'
require 'validators/date_validator'
require 'validators/domain_validator'
require 'validators/email_validator'
require 'validators/iban_validator'
require 'validators/phone_validator'
require 'validators/postal_code_validator'
require 'validators/vat_number_validator'

I18n.load_path += Dir["#{File.dirname(__FILE__)}/../config/locales/*.yml"]

module RailsValidations
end
