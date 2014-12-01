# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "color_generator"
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill McKinnon"]
  s.email       = ["bill.mckinnon@bmck.org"]
  s.homepage    = "http://rubygems.org/gems/color_generator"
  s.summary     = "Programmatic reproducible, pseudo-random color stream generator"
  s.description = "This gem provides a mechanism to create a reproducible stream of comparable colors "\
  "based on the work at http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/."
  s.license     = "GPLv2"

  s.required_rubygems_version = ">= 1.3.6"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
end
