# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'number_normalizer/version'

Gem::Specification.new do |spec|
  spec.name          = "number_normalizer"
  spec.version       = NumberNormalizer::VERSION
  spec.authors       = ["Dandan Wei"]
  spec.email         = ["dandan.wei@ymail.com"]

  spec.summary       = %q{Normalize and extract numbers writen as words or digits or mixed in a text}
  spec.description   = "In free texts, numbers maybe writen as digits (eg. 123.4) or words (eg. one hundred fifty) " \
                       "or a mixed way (eg. 1 million). This gem will help you to normalize or extract the numbers " \
                       "presented in the free text."
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "=> 1.10"
  spec.add_development_dependency "rake", "=> 10.0"
  spec.add_development_dependency "rspec", "=> 3.0"
end
