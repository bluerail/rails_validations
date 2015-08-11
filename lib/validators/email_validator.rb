# encoding: utf-8
#
# Validate email, also works with UTF-8/IDN.
#
# The validation is intentionally simply, you can never be sure an email is
# valid anyway (a user can mistype gmail as gmaill, for example).
#
# - User part: one or more characters except @ or whitespace.
# - Domain part: 1 or more character except @ or whitespace.
# - tld part: 2 or more word characters, numbers, or -
class EmailValidator < ActiveModel::EachValidator
  REGEXP = /\A
    [^@\s]+
    @
    ([\p{L}\d-]+\.)+  # \p{L} is any unicode character in the category "Letter"
    [\p{L}\d\-]{2,}
    \z
  /ix.freeze

  def validate_each record, attribute, value
    record.errors.add attribute, (options[:message] || I18n.t('rails_validations.email.invalid')) unless value =~ REGEXP
  end
end
