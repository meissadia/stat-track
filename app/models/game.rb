require 'benchmark'
require 'espnscrape'
require 'war'
include WAR

class Game < ActiveRecord::Base
  belongs_to :team
  # has_many :players, through: :team
  # has_many :gamestats, through: :players
  FIELD_NAMES_PG = [:t_abbr,:game_num,:gtime,:tv,:gdate,:home,:opp_abbr,:win,:team_score,:opp_score,:boxscore_id,:wins,:losses, :g_datetime]
  FIELD_NAMES_FG = [:t_abbr,:game_num,:win,:boxscore_id, :gdate,:home,:opp_abbr,:gtime, :tv, :g_datetime]

  def self.UpdateFromSchedule()
    gs_msgs = [] # Gamestat message
    ignore_fields_on_create = [:gtime, :g_datetime]
    ignore_fields_on_update = [:gtime, :g_datetime, :tv, :home, :game_num, :home, :opp_abbr]
    time = Benchmark.realtime do
      puts "Updating GameStats : #{Date.today.strftime("%F")}"
      es = EspnScrape.new
      Team.all.each do |team|
        print "Processing #{team.t_name}..."
        gs_msgs << "Processing #{team.t_name}..."
        cnt = 0
        fl_a  = []
        pgs = from_array2d(Game::FIELD_NAMES_PG, es.getSchedule(team.t_abbr).getPastGames())
        pgs.each do |pg|
          print '.'
          # Check if this boxscore_id has already been processed
          game = Game.find_by("team_id = ? AND boxscore_id = ?" , team.id, pg[:boxscore_id])
          if game.nil?
            # Boxscore not processed => Get info by Team.id, game_num
            game = Game.find_by("team_id = ? AND game_num = ?" , team.id, pg[:game_num])
            if !game.nil?
              ignore_fields_on_update.each { |f| pg.delete(f) }
              game.update(pg)
            else
              ignore_fields_on_create.each { |f| pg.delete(f) }
              Game.create(pg)
            end

            gs_msgs << "\n..Games: #{pg[:t_abbr]}(#{pg[:team_score]}) "\
            "%s #{pg[:opp_abbr]}(#{pg[:opp_score]}) updated."\
            % [pg[:home] ? "vs" : "@"]

            cnt += 1
            bs = es.getBoxscore(pg[:boxscore_id])
            fl_a += from_array2d(Gamestat::FIELD_NAMES, (pg[:home] ? bs.getHomeTeamPlayers : bs.getAwayTeamPlayers))
            fl_a.each do |fl| #set foreign keys
              fl[:player_id] = Player.getPlayerId(fl[:p_name])
              fl[:boxscore_id] = pg[:boxscore_id]
              fl[:opp_abbr] = pg[:home] ? bs.getTid(bs.getHomeTeamName) : bs.getTid(bs.getAwayTeamName)
              fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
              fl[:starter] = fl[:starter] == 'X' ? true : false
            end
            gs_msgs << "\n..GameStats: Game #{pg[:game_num]} vs #{pg[:opp_abbr]  } saved."
          end
        end
        Gamestat.create(fl_a)
        gs_msgs << " #{team.t_name}...#{cnt} games updated."
      end
    end
    return gs_msgs << "Update completed in #{time} sec"

  end
end
