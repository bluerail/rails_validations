# Check if this is a valid IBAN number; we use the +iban_tools+ gem for this.
class IbanValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      require 'iban-tools'
    rescue LoadError
      raise LoadError, 'The iban-tools gem is not installed. You need to add it to your Gemfile in order to use this validation'
    end

    return if value.blank?

    errors = IBANTools::IBAN.new(value).validation_errors
    return if errors.blank?

    if options[:message]
      record.errors.add attribute, options[:message]
    elsif options[:detailed_errors]
      errors.each { |e| record.errors.add attribute, I18n.t("rails_validations.iban.#{e}") }
    else
      record.errors.add attribute, I18n.t("rails_validations.iban.invalid")
    end
  end
end
