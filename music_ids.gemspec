# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'music_ids/version'

Gem::Specification.new do |spec|
  spec.name          = "music_ids"
  spec.version       = MusicIds::VERSION
  spec.authors       = ["Matt Patterson"]
  spec.email         = ["matt@reprocessed.org"]

  spec.summary       = %q{A library to handle parsing, normalisation, and output of music industry ID formats like ISRC and GRid}
  spec.description   = %q{music_ids contains classes that represent some of the main ID formats in use in the music industry for identifying individual pieces of recorded music.

There are often several ways that these IDs can be written, so the classes provide standard APIs to parse and normalise ID strings, as well as to break them into their components.}
  spec.homepage      = "https://github.com/tape-tv/music_ids"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "yard"
end
