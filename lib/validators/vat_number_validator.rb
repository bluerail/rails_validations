# We used wikipedia as a source:
# https://en.wikipedia.org/wiki/VAT_identification_number
class VatNumberValidator < ActiveModel::EachValidator
  # keys are ISO-3366-1 alpha2
  REGEXP = {
    # EU countries
    at: 'U\w{9}',
    be: '[01]\d{9}',
    bg: '\d9,10}',
    cy: '\w{9}',
    cz: '\d{9,10}',
    de: '\d{9}',
    dk: '\d{8}',             # TODO: Last digit is check digit
    ee: '\d{9}',
    el: '\d{9}',             # TODO: last digit is check digit
    es: '\w\d{7}\w',
    fi: '\d{8}',             # TODO: Last digit is a check digit utilizing MOD 11-2
    fr: '\w{2}\d{9}',        # TODO: first 2 are a validation key
    hr: '\d{11}',            # TODO: has check digit, ISO 7064, MOD 11-10
    hu: '\d{8}',
    it: '\d{11}',            # TODO: last digit is check digit
    lt: '(\d{9}|\d{12})',
    lu: '\d{8}',
    lv: '\d{11}',
    mt: '\d{8}',
    nl: '\d{9}B\d{2}',
    pl: '\d{10}',            # TODO: last digit is check digit
    pt: '\d{9}',             # TODO: last digit is check digit
    ro: '\d{2,10}',          # TODO: last digit is check digit
    se: '\d{10}01',
    si: '\d{8}',             # TODO: last digit is check digit
    sk: '\d{10}',            # TODO: number must be divisible by 11

    # - 'IE'+7 digits and one letter, optionally followed by a 'W' for married
    #   women, e.g. IE1234567T or IE1234567TW
    # - 'IE'+7 digits and two letters, e.g. IE1234567FA (since January 2013)
    # - 'IE'+one digit, one letter/"+"/"*", 5 digits and one letter (old style)
    ie: -> (v) {
      v =~ /\AIE\d{7}[A-Z]W?\z/ ||
        v =~ /\AIE\d{7}[A-Z]{2}\z/ ||
        v =~ /\AIE\d[A-Z+*]\d{5}[A-Z]\z/
    },

    gb: -> (v) {
      # - standard: 9 digits (block of 3, block of 4, block of 2 – e.g. GB999 9999 73)
      # - branch traders: 12 digits (as for 9 digits, followed by a block of 3 digits)
      # - government departments: the letters GD then 3 digits from 000 to 499 (e.g. GBGD001)
      # - health authorities: the letters HA then 3 digits from 500 to 999 (e.g. GBHA599)
      # TODO: validate check digits
      v =~ /\AGB\d{9}\z/ ||
        v =~ /\AGB\d{12}\z/ ||
        v =~ /\AGBGD[0-4]\d{2}\z/ ||
        v =~ /\AGBHA[5-9]\d{2}\z/
    },

    # Non-EU
    ch: '\d{9}', # TODO: last digit is a checksum digit, calculated according to ISO 7064, MOD 11-10
  }.freeze


  def validate_each record, attribute, value 
    key = (options[:country] || I18n.locale).downcase.to_sym
    key = :gb if key == :uk  # Since it's easy to get this wrong
    raise ArgumentError, "There is no validation for the country `#{key}'" if REGEXP[key].nil?

    # We always allow space, -, and . for formatting
    value = value.to_s.upcase.gsub(/[.\- ]/, '')

    valid = true
    if REGEXP[key].respond_to? :call
      valid = false unless REGEXP[key].call value
    elsif Regexp.new('\A' + key.upcase + value + '\z') !=~ REGEXP[key]
      valid = false
    end

    if !valid
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.vat_number.invalid'))
    end
  end
end

