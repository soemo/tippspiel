# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{passenger}
  s.version = "3.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Phusion - http://www.phusion.nl/}]
  s.date = %q{2011-11-28}
  s.description = %q{Easy and robust Ruby web application deployment.}
  s.email = %q{info@phusion.nl}
  s.executables = [%q{passenger}, %q{passenger-install-apache2-module}, %q{passenger-install-nginx-module}, %q{passenger-config}, %q{passenger-status}, %q{passenger-memory-stats}, %q{passenger-make-enterprisey}]
  s.files = [%q{bin/passenger}, %q{bin/passenger-install-apache2-module}, %q{bin/passenger-install-nginx-module}, %q{bin/passenger-config}, %q{bin/passenger-status}, %q{bin/passenger-memory-stats}, %q{bin/passenger-make-enterprisey}]
  s.homepage = %q{http://www.modrails.com/}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{passenger}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Easy and robust Ruby web application deployment}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0.8.1"])
      s.add_runtime_dependency(%q<fastthread>, [">= 1.0.1"])
      s.add_runtime_dependency(%q<daemon_controller>, [">= 0.2.5"])
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0.8.1"])
      s.add_dependency(%q<fastthread>, [">= 1.0.1"])
      s.add_dependency(%q<daemon_controller>, [">= 0.2.5"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.8.1"])
    s.add_dependency(%q<fastthread>, [">= 1.0.1"])
    s.add_dependency(%q<daemon_controller>, [">= 0.2.5"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
