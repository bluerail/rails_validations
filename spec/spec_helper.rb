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

#require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories in alphabetic order.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].sort.each { |f| require f }

I18n.enforce_available_locales = false if I18n.respond_to?(:enforce_available_locales)

I18n.load_path += Dir["#{File.dirname(__FILE__)}/../config/locales/*.yml"]


module ValidationsSpecHelper
  include ActiveSupport
  include ActionPack
  include ActionView::Context if defined?(ActionView::Context)
  include ActionController::RecordIdentifier if defined?(ActionController::RecordIdentifier)
  include ActionView::RecordIdentifier if defined?(ActionView::RecordIdentifier)


  class Record
    extend ActiveModel::Naming # if defined?(ActiveModel::Naming)
    include ActiveModel::Conversion# if defined?(ActiveModel::Conversion)
    include ActiveModel::Validations# if defined?(ActiveModel::Validations)


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
