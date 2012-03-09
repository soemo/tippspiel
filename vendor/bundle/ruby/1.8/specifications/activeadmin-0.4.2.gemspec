# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{activeadmin}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Greg Bell}]
  s.date = %q{2012-02-21}
  s.description = %q{The administration framework for Ruby on Rails.}
  s.email = [%q{gregdbell@gmail.com}]
  s.homepage = %q{http://activeadmin.info}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{The administration framework for Ruby on Rails.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<bourbon>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<meta_search>, [">= 0.9.2"])
      s.add_runtime_dependency(%q<devise>, [">= 1.1.2"])
      s.add_runtime_dependency(%q<formtastic>, [">= 2.0.0"])
      s.add_runtime_dependency(%q<inherited_resources>, ["> 0"])
      s.add_runtime_dependency(%q<kaminari>, [">= 0.13.0"])
      s.add_runtime_dependency(%q<sass>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<fastercsv>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<jquery-rails>, [">= 1.0.0"])
      s.add_dependency(%q<bourbon>, [">= 1.0.0"])
      s.add_dependency(%q<meta_search>, [">= 0.9.2"])
      s.add_dependency(%q<devise>, [">= 1.1.2"])
      s.add_dependency(%q<formtastic>, [">= 2.0.0"])
      s.add_dependency(%q<inherited_resources>, ["> 0"])
      s.add_dependency(%q<kaminari>, [">= 0.13.0"])
      s.add_dependency(%q<sass>, [">= 3.1.0"])
      s.add_dependency(%q<fastercsv>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<jquery-rails>, [">= 1.0.0"])
    s.add_dependency(%q<bourbon>, [">= 1.0.0"])
    s.add_dependency(%q<meta_search>, [">= 0.9.2"])
    s.add_dependency(%q<devise>, [">= 1.1.2"])
    s.add_dependency(%q<formtastic>, [">= 2.0.0"])
    s.add_dependency(%q<inherited_resources>, ["> 0"])
    s.add_dependency(%q<kaminari>, [">= 0.13.0"])
    s.add_dependency(%q<sass>, [">= 3.1.0"])
    s.add_dependency(%q<fastercsv>, [">= 0"])
  end
end
