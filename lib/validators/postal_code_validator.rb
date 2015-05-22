class PostalCodeValidator < ActiveModel::EachValidator
  # keys are ISO-3366-1 alpha2
  REGEXP = {
    nl: /\A\d{4}\s*?\w{2}\z/,
  }.freeze


  def validate_each record, attribute, value 
    key = (options[:country] || I18n.locale).downcase.to_sym
    key = :gb if key == :uk  # Since it's easy to get this wrong
    raise ArgumentError, "There is no validation for the country `#{key}'" if REGEXP[key].nil?

    record.errors.add attribute, (options[:message] || I18n.t('rails_validations.postal_code.invalid')) unless value =~ REGEXP[key]
  end
end
