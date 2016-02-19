$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'webmock/rspec'
require 'munson'
require 'pry-byebug'

require 'support/macros/json_api_document_macros'
require 'support/macros/model_macros'
require 'support/matchers/have_data'
require 'support/app'

WebMock.disable_net_connect!

RSpec.configure do |c|
  c.include Munson::RSpec::Macros::JsonApiDocumentMacros
  c.include Munson::RSpec::Macros::ModelMacros

  c.before(:each){ @spawned_models = [] }
  c.after :each do
    @spawned_models.each do |model|
      Object.instance_eval { remove_const model } if Object.const_defined?(model)
    end
  end
end
