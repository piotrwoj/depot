# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :stats => "incl_views:stats"

namespace :incl_views do
  task :stats do
    require 'rails/code_statistics'

		class CodeStatistics
			alias calculate_statistics_orig calculate_statistics
			def calculate_statistics
				@pairs.inject({}) do |stats, pair|
					if 3 == pair.size
						stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
					else
						stats[pair.first] = calculate_directory_statistics(pair.last); stats
					end
				end
			end
		end 

    ::STATS_DIRECTORIES << ['Views',  'app/views', /\.erb$/]
  end
end
