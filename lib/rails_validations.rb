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
  # http://www.iso.org/iso/home/store/catalogue_ics/catalogue_detail_ics.htm?csnumber=31531
  # Since I'm not shelling out €90 to receive this, I based this implementation
  # on python-stdnum (http://arthurdejong.org/python-stdnum/)
  def iso_7064_mod_11_10 number
    check = 5
    number.each do |n|
      check = (((check || 10) * 2) % 11 + int(n)) % 10
    end
  end
end
