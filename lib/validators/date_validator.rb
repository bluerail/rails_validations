class DateValidator < ActiveModel::EachValidator
  CHECKS = {
    # These keys make the most sense for dates
    after: :>,
    after_or_equal_to: :>=,
    equal_to: :==,
    before: :<,
    before_or_equal_to: :<=,

    # For compatibility with numericality
    #greater_than: :>,
    #greater_than_or_equal_to: :>=,
    #less_than: :<,
    #less_than_or_equal_to: :<=,
  }.freeze


  def validate_each record, attribute, raw_value
    # TODO: Do we need to do anything with timezones? Figure it out (rails has
    # ActiveSupport::TimeWithZone)...
    value = if raw_value.is_a? Fixnum
              time.at(raw_value).to_date
            elsif raw_value.respond_to? :to_date
              raw_value.to_date
            else
              false
            end

            #elsif raw_value.is_a?(Symbol) || raw_value.is_a?(String)
            #  # Assume another (date) attribute
            #  record.send(raw_value).to_date

    unless value
      record.errors.add attribute, I18n.t('rails_validations.date.invalid')
      return
    end

    options.slice(*CHECKS.keys).each do |option, raw_option_value|
      option_value = if raw_option_value.respond_to? :call
                       raw_option_value.call record
                     elsif raw_option_value.is_a? Symbol
                       record.send raw_option_value
                     elsif raw_option_value.is_a? Fixnum
                       time.at(raw_option_value).to_date
                     elsif raw_option_value.respond_to? :to_date
                       raw_option_value.to_date
                     else
                       raise ArgumentError
                     end

      unless option_value
        record.errors.add attribute, I18n.t('rails_validations.date.invalid')
        return
      end

      unless value.send CHECKS[option], option_value
        record.errors.add attribute, I18n.t("rails_validations.date.#{option}", date: I18n.l(option_value))
      end
    end
  end
end
