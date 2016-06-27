require_relative './seeds_config'
require_relative './SeedDB'

time = Benchmark.realtime do
  s_db = SeedDB.new
  USE_STORED_DATA ? s_db.seed_from_file : s_db.seed_from_web
end
puts "Completed in %i:%.f min" % [time / 60, (time % 60).round]


# BOX_P = [:t_abbr, :p_eid, :p_name, :pos, :min, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :plus, :pts, :starter]
# BOX_T   = [:t_abbr, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb,      :ast,     :stl,    :blk,    :tos,       :pf,    :pts]
# GAME_F   = [:t_abbr, :game_num, :gdate, :home, :opp_abbr, :gtime, :tv, :g_datetime, :season_type]
# GAME_P   = [:t_abbr, :game_num, :gdate, :home, :opp_abbr, :win, :team_score, :opp_score, :boxscore_id, :wins, :losses, :g_datetime, :season_type]
# ROSTER   = [:t_abbr, :p_num,  :p_name, :p_eid, :pos,      :age, :h_ft,      :h_in,      :weight, :college, :salary]
# TEAM   = [:t_abbr, :t_name, :division, :conference]
