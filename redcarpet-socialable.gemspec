# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "redcarpet-socialable"
  spec.version       = "0.0.2"
  spec.authors       = ["Jan Bernacki"]
  spec.email         = ["releu@me.com"]
  spec.description   = %q{@mention and #hashtag features for redcarpet}
  spec.summary       = %q{@mention and #hashtag features for redcarpet, the Markdown renderer}
  spec.homepage      = "https://github.com/releu/redcarpet-socialable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "redcarpet", ">= 3.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
