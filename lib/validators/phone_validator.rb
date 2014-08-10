class PhoneValidator < ActiveModel::EachValidator
  REGEXP = /\A
    (\(?\+\d+\)?)?    # optional country code
    [0-9 \-.()]{4,20}
  \z/x.freeze

  def validate_each record, attribute, value
    record.errors.add attribute, (options[:message] || I18n.t('rails_validations.invalid_phone')) unless value =~ REGEXP
  end
end
