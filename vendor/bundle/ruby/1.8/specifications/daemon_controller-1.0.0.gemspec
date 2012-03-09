# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{daemon_controller}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Hongli Lai}]
  s.date = %q{2012-02-04}
  s.description = %q{A library for robust daemon management.}
  s.email = %q{hongli@phusion.nl}
  s.homepage = %q{https://github.com/FooBarWidget/daemon_controller}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{A library for implementing daemon management capabilities}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
