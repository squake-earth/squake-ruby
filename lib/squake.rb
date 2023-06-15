# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'
require 'oj'
require 'net/http'

Dir[File.join(__dir__, './**/*', '*.rb')].each { require(_1) }

module Squake; end
