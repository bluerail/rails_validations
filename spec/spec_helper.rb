ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require 'bundler/setup'

require 'action_controller'
require 'action_dispatch'
require 'action_pack'
require 'action_view'
require 'active_model'
require 'active_record'
require 'active_support'
require 'active_support/all'


# Include our validators
Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].sort.each { |f| require f }

# Make sure I18N works
I18n.enforce_available_locales = false if I18n.respond_to?(:enforce_available_locales)
I18n.load_path += Dir["#{File.dirname(__FILE__)}/../config/locales/*.yml"]


module ValidationsSpecHelper
  include ActiveSupport
  include ActionPack
  include ActionView::Context if defined?(ActionView::Context)
  include ActionController::RecordIdentifier if defined?(ActionController::RecordIdentifier)
  include ActionView::RecordIdentifier if defined?(ActionView::RecordIdentifier)


  class Record
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def initialize attr={}
      attr.each { |k, v| send("#{k}=", v) }
      super()
    end


    def v; @value end
    def v= v; @value = v end
    def v2; @value2 end
    def v2= v; @value2 = v end
  end


  def model v, v2=nil
    described_class.new v: v, v2: v2
  end


  def model_errors v
    m = model v
    m.valid?
    return m.errors[:v]
  end


  def with_validation validate_string
    described_class.clear_validators!
    described_class.class_eval "validates :v, #{validate_string}"

    yield
  end
end


RSpec::Matchers.define :be_valid do
  match { |record | record.valid? == true && record.errors.blank? }
end

RSpec::Matchers.define :be_invalid do |i18n_key, i18n_params={}|
  match do |record|
    record.valid? == false &&
      record.errors.first.present? &&
      record.errors.first[1] == I18n.t("rails_validations.#{i18n_key}", **i18n_params)
  end
end


shared_examples :validation do |validation|
  it 'accepts a custom error message' do
    with_validation "#{validation}: { country: :nl, message: 'foobar' }" do
      m = described_class.new v: 'not even remotely valid'
      expect(m.valid?).to eq(false)
      expect(m.errors[:v].first).to eq('foobar')
    end
  end
end


shared_examples :country_code do |validation|
  it 'raises an error on an invalid country' do
    with_validation "#{validation}: { country: :not_a_country_code }" do
      expect { described_class.new(v: 123).valid? }.to raise_error(ArgumentError)
    end
  end
end
