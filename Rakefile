require 'rspec'
require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new
task :default => :spec

task :compile do
  sh 'bin/render'
end

task :deploy => :compile do
  sh %Q(rsync -a index.html kschiess@wikileakmirrors.ch:wikileakmirrors.ch/)
  sh %Q(rsync -a css index.html kschiess@wikileakmirrors.ch:wikileakmirrors.ch/)
end