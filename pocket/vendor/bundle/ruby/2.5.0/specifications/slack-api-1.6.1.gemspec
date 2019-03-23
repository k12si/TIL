# -*- encoding: utf-8 -*-
# stub: slack-api 1.6.1 ruby lib

Gem::Specification.new do |s|
  s.name = "slack-api".freeze
  s.version = "1.6.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["aki017".freeze]
  s.date = "2018-01-20"
  s.description = "A Ruby wrapper for the Slack API".freeze
  s.email = ["aki@aki017.info".freeze]
  s.homepage = "https://github.com/aki017/slack-ruby-gem".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "A Ruby wrapper for the Slack API".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<vcr>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<erubis>.freeze, ["~> 2.7.0"])
      s.add_development_dependency(%q<json-schema>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<faraday>.freeze, ["~> 0.11"])
      s.add_runtime_dependency(%q<faraday_middleware>.freeze, ["~> 0.10.0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, [">= 1.0.3", "~> 1.0"])
      s.add_runtime_dependency(%q<faye-websocket>.freeze, ["~> 0.10.6"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<coveralls>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_dependency(%q<vcr>.freeze, [">= 0"])
      s.add_dependency(%q<guard>.freeze, [">= 0"])
      s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<erubis>.freeze, ["~> 2.7.0"])
      s.add_dependency(%q<json-schema>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<faraday>.freeze, ["~> 0.11"])
      s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.10.0"])
      s.add_dependency(%q<multi_json>.freeze, [">= 1.0.3", "~> 1.0"])
      s.add_dependency(%q<faye-websocket>.freeze, ["~> 0.10.6"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.5"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<vcr>.freeze, [">= 0"])
    s.add_dependency(%q<guard>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<erubis>.freeze, ["~> 2.7.0"])
    s.add_dependency(%q<json-schema>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<faraday>.freeze, ["~> 0.11"])
    s.add_dependency(%q<faraday_middleware>.freeze, ["~> 0.10.0"])
    s.add_dependency(%q<multi_json>.freeze, [">= 1.0.3", "~> 1.0"])
    s.add_dependency(%q<faye-websocket>.freeze, ["~> 0.10.6"])
  end
end
