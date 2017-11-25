# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ds_media_library/version'

Gem::Specification.new do |spec|
  spec.name          = "ds_media_library"
  spec.version       = DSMediaLibrary::VERSION
  spec.authors       = ["Micah Geisel"]
  spec.email         = ["micah@botandrose.com"]

  spec.summary       = 'Downstream Media Library Rails Engine'
  spec.description   = 'Downstream Media Library Rails Engine'
  spec.homepage      = "https://github.com/botandrose/ds_media_library"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber-rails"
  spec.add_development_dependency "chop"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "poltergeist"
  spec.add_development_dependency "phantomjs"
  spec.add_development_dependency "capybara-screenshot"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "byebug"

  spec.add_dependency "rails"
  spec.add_dependency "slim"
  spec.add_dependency "ds_node"
  spec.add_dependency "awesome_nested_set"
  spec.add_dependency "coffee-rails"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "jquery-ui-rails"
end
