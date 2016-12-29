#!/usr/bin/env rake

desc 'Runs cookstyle linter'
task :cookstyle do
  if Gem::Version.new('2.1.8') <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), %w(tmp foodcritic cookbook))
    prepare_foodcritic_sandbox(sandbox)

    sh "cookstyle --display-cop-names --fail-level A #{File.dirname(sandbox)}"
  else
    puts "WARN: cookstyle run is skipped as Ruby #{RUBY_VERSION} is < 2.1.8."
  end
end

desc 'Runs rubocop linter'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end

task default: 'cookstyle'
task default: 'rubocop'

private

def prepare_foodcritic_sandbox(sandbox)
  files = %w( *.md
              *.rb
              attributes
              definitions
              files
              libraries
              providers
              recipes
              resources
              templates )

  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
  puts "\n\n"
end
