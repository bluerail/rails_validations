require 'validators/date_validator'
require 'validators/domain_validator'
require 'validators/email_validator'
require 'validators/iban_validator'
require 'validators/phone_validator'
require 'validators/postal_code_validator'
#require 'validators/presence_of_validator'

I18n.load_path += Dir["#{File.dirname(__FILE__)}/../config/locales/*.yml"]

module RailsValidations
end
