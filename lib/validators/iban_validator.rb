class IbanValidator < ActiveModel::EachValidator

  def validate_each record, attribute, value
    require 'iban-tools'

    return if value.blank?

    errors = IBANTools::IBAN.new(value).validation_errors
    return if errors.blank?

    if options[:message]
      record.errors.add attribute, options[:message]
    else
      errors.each { |e| record.errors.add attribute, I18n.t("rails_validations.iban.#{e}") }
    end
  end
end
