# https://en.wikipedia.org/wiki/VAT_identification_number
# http://ec.europa.eu/taxation_customs/vies/faqvies.do#item_7
class VatNumberValidator < ActiveModel::EachValidator
  # keys are ISO-3366-1 alpha2
  REGEXP = {
    # 'NL' + 9 digits + B + 2-digit company index – e.g. NL999999999B99
    # Allow space, -, and . for formatting
    # TODO: I think this also has a check digit?
    nl: ->(v) { v.upcase.gsub(/[.\- ]/, '') =~ /\ANL\d{9}B\d{2}\z/ },
  }.freeze


  def validate_each record, attribute, value 
    key = (options[:country] || I18n.locale).downcase.to_sym
    key = :gb if key == :uk  # Since it's easy to get this wrong
    raise ArgumentError, "There is no validation for the country `#{key}'" if REGEXP[key].nil?

    value = value.to_s

    valid = true
    if REGEXP[key].respond_to? :call
      valid = false unless REGEXP[key].call value
    elsif value !=~ REGEXP[key]
      valid = false
    end

    if !valid
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.vat_number.invalid'))
    end
  end
end

