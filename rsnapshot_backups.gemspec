$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rsnapshot_backups/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rsnapshot_backups"
  s.version     = RsnapshotBackup::VERSION
  s.authors     = ["sukhbir singh"]
  s.email       = ["sukhbir947@gmail.com"]
  s.homepage    = "http://www.amahi.org/apps/yourapp"
  s.license     = "AGPLv3"
  s.summary     = %{Amahi plugin to create incremental backups using rsnaphot periodically.}
  s.description = %{This is an Amahi 11 platform plugin that creates periodic backups using rsnapshot tool.}

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
