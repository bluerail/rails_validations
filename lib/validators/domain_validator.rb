# encoding: utf-8
#
# Validate if a string is a valid domain. This should work with IDN.
#
#  validates :domain_column, domain: true
#
# Set a minimum and maximum number of domain parts (aka. labels)
#
#  validates :domain_column, domain: { min_domain_parts: 2 }
#  validates :domain_column, domain: { max_domain_parts: 2 }
class DomainValidator < ActiveModel::EachValidator
  # RFC 1034, section 3.1:
  # Each node has a label, which is zero to 63 octets in length. 
  #
  # RFC 1035, secion 2.3.1:
  # <label> ::= <letter> [ [ <ldh-str> ] <let-dig> ]
  #
  # <let-dig> ::= <letter> | <digit>
  #
  # <letter> ::= any one of the 52 alphabetic characters A through Z in
  # upper case and a through z in lower case
  #
  # <digit> ::= any one of the ten digits 0 through 9
  #
  # [...]
  #
  # Labels must be 63 characters or less.
  #
  # TODO: There are more considerations, especially for IDN. RFC5891 section 4.2
  # lists some.
  REGEXP = /
    \A
    [\p{L}\d-]{1,63}  # \p{L} is any unicode character in the category "Letter"
    \z
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
