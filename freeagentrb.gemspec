# frozen_string_literal: true

require_relative "lib/free_agent/version"

Gem::Specification.new do |spec|
  spec.name = "freeagentrb"
  spec.version = FreeAgent::VERSION
  spec.authors = [ "Dean Perry" ]
  spec.email = [ "dean@deanpcmad.com" ]

  spec.summary = "Ruby library for the FreeAgent v2 API"
  spec.homepage = "https://deanpcmad.com"

  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/deanpcmad/freeagentrb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = [ "lib" ]

  spec.add_dependency "faraday", "~> 2.11"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "ostruct", "~> 0.6.0"
end
