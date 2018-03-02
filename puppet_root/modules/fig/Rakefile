require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-parse/puppet-parse'
require 'puppet-syntax/tasks/puppet-syntax'

PuppetLint.configuration.send("disable_80chars")

PuppetSyntax.fail_on_deprecation_notices = false

desc "Run syntax, lint, and parse tests."
task :test => [
  'syntax:manifests',
  :lint,
  :parse,
  :metadata,
]