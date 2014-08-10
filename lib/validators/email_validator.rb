# Validate email, also works with UTF-8/IDN.
#
# The validation is intentionally simply, you can never be sure an email is
# valid anyway (a user can mistype gmail as gmaill, for example).
#
# - user part: one or more characters except @ or whitespace.
# - domain part: 2 or more character except @ or whitespace.
# - tld part: 2 or more word characters *or* -
class EmailValidator < ActiveModel::EachValidator
  REGEXP = /\A
    [^@\s]+
    @
    [^@\s.]+
    \.
    [\p{L}0-9\-]{2,}
  \z/ix.freeze

  def validate_each record, attribute, value
    record.errors.add attribute, (options[:message] || I18n.t('rails_validations.email.invalid')) unless value =~ REGEXP
  end
end
