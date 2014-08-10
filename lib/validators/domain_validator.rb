class DomainValidator < ActiveModel::EachValidator
  #\A[a-zA-Z\d-]{,63}\z
  REGEXP = /
    \A[\p{L}\d-]{1,63}\z
  /ix.freeze

  def validate_each record, attribute, value
    parts = value.split '.'

    parts.each do |part|
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.domain.invalid')) unless part =~ REGEXP
    end

    if options[:max_domain_parts].present? && parts.length > options[:max_domain_parts]
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.domain.max_domain_parts', max: options[:max_domain_parts]))
    end

    if options[:min_domain_parts].present? && options[:min_domain_parts] > parts.length
      record.errors.add attribute, (options[:message] || I18n.t('rails_validations.domain.min_domain_parts', min: options[:min_domain_parts]))
    end
  end
end
