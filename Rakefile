# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

if Gem.win_platform? && defined?(Cssbundling::Tasks)
  module Cssbundling::Tasks
    # cssbundling-rails uses the POSIX `command -v`, which is not available in cmd.exe.
    def self.tool_exists?(tool)
      system("#{tool}.cmd --version > NUL 2>&1")
    end
  end
end
