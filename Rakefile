require "bundler/gem_tasks"

task default: %w[buildjaguar]

task :buildparser do
  puts "Building Parser"
  sh "racc -o lib/jaguar/parser.rb lib/jaguar/grammar.y"
end

task :buildjaguar do
  puts "Building..."
  sh ""
end
