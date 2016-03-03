ENV['RAILS_ENV'] ||= 'test'
ENV['MENTIONS_MAPPING_FILE_PATH'] = "#{Rails.root}/test/files/mention_mappings.yml"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
  fixtures :all
end
