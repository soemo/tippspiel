# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{responders}
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{José Valim}]
  s.date = %q{2012-03-06}
  s.description = %q{A set of Rails 3 responders to dry up your application}
  s.email = %q{contact@plataformatec.com.br}
  s.homepage = %q{http://github.com/plataformatec/responders}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{responders}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A set of Rails 3 responders to dry up your application}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["~> 3.1"])
    else
      s.add_dependency(%q<railties>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<railties>, ["~> 3.1"])
  end
end
