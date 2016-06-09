require_relative './seeds_config'
require_relative './SeedDB'

time = Benchmark.realtime do
  s_db = SeedDB.new
  USE_STORED_DATA ? s_db.seed_from_file : s_db.seed_from_web
end
puts "Completed in %i:%.f min" % [time / 60, (time % 60).round]
