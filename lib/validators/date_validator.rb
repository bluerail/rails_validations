# Validate if a column is a valid date, and if it's before or after another date.
# 
#  validates :date_column, date: true
#  validates :date_column, date: { after: Date.today }
#  validates :date_column, date: { after_or_equal_to: Date.today }
#  validates :date_column, date: { equal_to: Date.today }
#  validates :date_column, date: { before: Date.today }
#  validates :date_column, date: { before_or_equal_to: Date.today }
# 
# Check if the column `enddate` is after the value of the column `begindate`
#   validates :begindate, date: true
#   validates :enddate, date: { after: :begindate }
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


  def value_to_date raw_value
    # TODO: Do we need to do anything with timezones? Figure it out (rails has
    # ActiveSupport::TimeWithZone)...
    if raw_value.is_a? Fixnum
      time.at(raw_value).to_date
    elsif raw_value.respond_to? :to_date
      begin
        raw_value.to_date
      rescue ArgumentError
        false
      end
    else
      false
    end
  end


  def validate_each record, attribute, raw_value
    value = value_to_date raw_value

    unless value
      record.errors.add attribute, I18n.t('rails_validations.date.invalid')
      return
    end

    options.slice(*CHECKS.keys).each do |option, raw_option_value|
      option_value = if raw_option_value.respond_to? :call
                       if raw_option_value.parameters == []
                         raw_option_value.call
                       else
                         raw_option_value.call record
                       end
                     elsif raw_option_value.is_a? Symbol
                       value_to_date record.send(raw_option_value)
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
