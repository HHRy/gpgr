# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gpgr/version"

Gem::Specification.new do |spec|
  spec.name          = "gpgr"
  spec.version       = Gpgr::VERSION
  spec.authors       = ["Ryan Stenhouse"]
  spec.email         = ["ryan@ryanstenhouse.eu"]

  spec.summary       = %q{A lightweight GPG CLI interface for encyrypting files}
  spec.description   = <<-END_DESC
    gpgr is a very light interface to the command-line GPG (GNU
    Privacy Guard) tool which is soley concerned with making it
    as easy as possible to encrypt files with one (or more) public
    keys.
    It does not provide any major key management tools and does not
    support decryption.
  END_DESC
  spec.homepage      = "https://ryanstenhouse.jp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "minitest"#, "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
