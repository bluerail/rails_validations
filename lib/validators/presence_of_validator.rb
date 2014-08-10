# Test the presence of attributes from a belongs_to.
#
# For example, doing this in the User model:
#
#   belongs_to :person
#   validates :person, presence_of: :initials
#
# would be the same as your User model containing:
#
#   has_one :user, inverse_of: :person
#   has_one :admin, inverse_of: :person
#
#   validates :initials, if: :user
#
# TODO: Unfinished, copied from K4K
class PresenceOfValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
  	errortext = if options[:with].to_s.pluralize == options[:with].to_s
                  I18n.t('errors.messages.empty_plural')
                else
                  I18n.t('errors.messages.empty')
                end

    if record.send(attribute) && record.send(attribute).send(options[:with]).blank?
      record.send(attribute).errors[options[:with]] << errortext
      record.errors["#{attribute}.#{options[:with]}"] << errortext
    end
  end
end
