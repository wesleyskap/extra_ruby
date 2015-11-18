require 'rubygems'
require 'bundler/setup'
require 'webmock'
require 'vcr'
require 'extra'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

RSpec.configure do |config|
end

config = YAML.load(File.read('spec/config.yml'))
Extra.config! app_token: config['app_token'], auth_token: config['auth_token'], sandbox: config['sandbox']
