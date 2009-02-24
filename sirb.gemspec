# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sirb}
  s.version = "0.6.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Richards"]
  s.date = %q{2009-02-24}
  s.default_executable = %q{sirb}
  s.description = %q{TODO}
  s.email = %q{davidlamontrichards@gmail.com}
  s.executables = ["sirb"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/sirb", "lib/overrides", "lib/overrides/array.rb", "lib/overrides/file.rb", "lib/overrides/module.rb", "lib/overrides/symbol.rb", "lib/sirb", "lib/sirb/enumerable_statistics.rb", "lib/sirb/functional.rb", "lib/sirb/general_statistics.rb", "lib/sirb/inter_enumerable_statistics.rb", "lib/sirb/loader.rb", "lib/sirb/runner.rb", "lib/sirb/sproc.rb", "lib/sirb/unbound_method.rb", "lib/sirb.rb", "lib/stored_procedures.rb", "lib/version.rb", "spec/lib", "spec/lib/overrides", "spec/lib/overrides/array_spec.rb", "spec/lib/overrides/file_spec.rb", "spec/lib/overrides/module_spec.rb", "spec/lib/overrides/symbol_spec.rb", "spec/lib/sirb", "spec/lib/sirb/enumerable_statistics_spec.rb", "spec/lib/sirb/functional_spec.rb", "spec/lib/sirb/general_statistics_spec.rb", "spec/lib/sirb/inter_enumerable_statistics_spec.rb", "spec/lib/sirb/loader_spec.rb", "spec/lib/sirb/runner_spec.rb", "spec/lib/sirb/unbound_method_spec.rb", "spec/lib/sirb_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/davidrichards/sirb}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end