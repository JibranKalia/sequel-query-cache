# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sequel-cacheable"
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sho Kusano <rosylilly>"]
  s.date = "2012-05-01"
  s.description = "This plug-in caching mechanism to implement the Model of the Sequel"
  s.email = "rosylilly@aduca.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/sequel-cacheable.rb",
    "sequel-cacheable.gemspec",
    "spec/lib/sequel-cacheable_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/rosylilly/sequel-cacheable"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.22"
  s.summary = "This plug-in caching mechanism to implement the Model of the Sequel"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, ["~> 3.34"])
      s.add_runtime_dependency(%q<msgpack>, ["~> 0.4.6"])
      s.add_runtime_dependency(%q<hashr>, ["~> 0.0.19"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2"])
      s.add_development_dependency(%q<yard>, ["~> 0.7"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.6.1"])
      s.add_development_dependency(%q<guard>, ["~> 1.0.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.7"])
      s.add_development_dependency(%q<growl>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<memcache>, [">= 0"])
      s.add_development_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<queencheck>, [">= 0"])
    else
      s.add_dependency(%q<sequel>, ["~> 3.34"])
      s.add_dependency(%q<msgpack>, ["~> 0.4.6"])
      s.add_dependency(%q<hashr>, ["~> 0.0.19"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2"])
      s.add_dependency(%q<yard>, ["~> 0.7"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<simplecov>, ["~> 0.6.1"])
      s.add_dependency(%q<guard>, ["~> 1.0.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.7"])
      s.add_dependency(%q<growl>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<memcache>, [">= 0"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<queencheck>, [">= 0"])
    end
  else
    s.add_dependency(%q<sequel>, ["~> 3.34"])
    s.add_dependency(%q<msgpack>, ["~> 0.4.6"])
    s.add_dependency(%q<hashr>, ["~> 0.0.19"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2"])
    s.add_dependency(%q<yard>, ["~> 0.7"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<simplecov>, ["~> 0.6.1"])
    s.add_dependency(%q<guard>, ["~> 1.0.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.7"])
    s.add_dependency(%q<growl>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<memcache>, [">= 0"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<queencheck>, [">= 0"])
  end
end

