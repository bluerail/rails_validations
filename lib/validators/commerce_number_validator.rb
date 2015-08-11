# Chamber of commerce number
class CommerceNumberValidator < ActiveModel::EachValidator
  # keys are ISO-3366-1 alpha2
  REGEXP = {
    # KvK nummer; 8 digits. Allow space, -, and . for formatting
    nl: ->(v) { v.gsub(/[.\- ]/, '') =~ /\A\d{8}\z/ },
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
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.commerce_number.invalid'))
    end
  end
end
