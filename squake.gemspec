lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squake/version'

Gem::Specification.new do |spec|
  spec.name                  = 'squake'
  spec.version               = Squake::VERSION
  spec.summary               = 'The industry solution for sustainable travel and logistics.'
  spec.description           = 'This gem provides an interface for the SQUAKE API to calculate and compensate carbon emissions.' # rubocop:disable Layout/LineLength
  spec.author                = 'SQUAKE'
  spec.email                 = 'oss@squake.earth'
  spec.files                 = Dir[
    'lib/**/*',
    'sorbet/rbi/dsl/**/*.rbi',
    'sorbet/rbi/shims/**/*.rbi',
    'LICENSE',
    'README.md',
    'CHANGELOG.md',
  ]
  spec.homepage              = 'https://github.com/squake-earth/squake-ruby'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'net-http'
  spec.add_dependency 'oj'
  spec.add_dependency 'sorbet-runtime'
  spec.add_dependency 'uri'

  spec.add_development_dependency 'base64' # removed in Ruby 3.4, subdependency of VCR
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop-dbl'
  spec.add_development_dependency 'spoom'
  spec.add_development_dependency 'tapioca'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
