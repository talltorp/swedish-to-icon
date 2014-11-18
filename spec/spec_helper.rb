ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require 'webmock/rspec'
require 'pullreview/coverage_reporter'

PullReview::CoverageReporter.start

WebMock.disable_net_connect!(allow_localhost: true)

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = true
  config.order = "random"
end

RSpec::Matchers.define :have_same_attributes_as do |expected|
  match do |actual|
    ignored = [:id, :updated_at, :created_at]
    actual.attributes.except(*ignored) == expected.attributes.except(*ignored)
  end
end
