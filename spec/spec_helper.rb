require 'rspec'
require 'json'
require 'date'

require_relative '../lib/navigation'
require_relative '../lib/creative_work'
require_relative '../lib/core_client'

def fixture path
  dir = File.dirname(__FILE__)
  File.open("#{dir}/fixtures/#{path}", "rb").read
end

def json_fixture path
  JSON.parse(fixture path)
end