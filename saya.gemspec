# -*- encoding: utf-8 -*-
# stub: saya 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "saya"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2013-09-28"
  s.description = "Saya helps you post a post to different SNS simultaneously.\n\nIt is intended to provide a reference usage for [Jellyfish](https://github.com/godfat/jellyfish)."
  s.email = ["godfat (XD) godfat.org"]
  s.executables = ["saya"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  ".travis.yml",
  "CHANGES.md",
  "Gemfile",
  "LICENSE",
  "README.md",
  "Rakefile",
  "bin/saya",
  "config.ru",
  "config/auth.yaml",
  "config/rainbows.rb",
  "config/zbatery.rb",
  "lib/saya.rb",
  "lib/saya/api.rb",
  "lib/saya/init.rb",
  "lib/saya/runner.rb",
  "lib/saya/version.rb",
  "public/index.html",
  "public/jellyfish.png",
  "public/script.js",
  "public/spinner.gif",
  "public/style.css",
  "saya.gemspec",
  "task/.gitignore",
  "task/gemgem.rb"]
  s.homepage = "https://github.com/godfat/saya"
  s.licenses = ["Apache License 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.5"
  s.summary = "Saya helps you post a post to different SNS simultaneously."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<jellyfish>, [">= 0"])
      s.add_runtime_dependency(%q<rest-more>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rack-handlers>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<jellyfish>, [">= 0"])
      s.add_dependency(%q<rest-more>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rack-handlers>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<jellyfish>, [">= 0"])
    s.add_dependency(%q<rest-more>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rack-handlers>, [">= 0"])
  end
end
