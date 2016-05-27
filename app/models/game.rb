require 'benchmark'
require 'espnscrape'
require 'war'
include WAR

class Game < ActiveRecord::Base
  belongs_to :team
  # has_many :players, through: :team
  # has_many :gamestats, through: :players
  FIELD_NAMES_PG = EspnScrape::FS_SCHEDULE_PAST
  FIELD_NAMES_FG = EspnScrape::FS_SCHEDULE_FUTURE


  def self.getGameNum(t_abbr, boxscore_id)
    g = Game.where("t_abbr = ? AND boxscore_id = ?", t_abbr, boxscore_id)
    if !g.nil?
      return g[0].game_num
    else
      return 0
    end
  end

  # Erase existing Schedule data and replace
  def self.refreshSchedule(team, teamSchedule)
    # Delete all Schedule records for this team
    Game.where(team_id: team.id).destroy_all

    fl_a = from_array2d(Game::FIELD_NAMES_PG, teamSchedule.getPastGames)
    fl_a += from_array2d(Game::FIELD_NAMES_FG, teamSchedule.getFutureGames)
    # Set Foreign Keys
    fl_a.each do |fl|
      print "."
      fl[:team_id] = team.id
      fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
      fl[:gdate] = fl[:g_datetime]    # Utilize Game DateTime as Game Date
      fl.delete(:g_datetime)          # Eliminate DateTime, now stored in gdate
      fl.delete(:gtime)               # Eliminate Game Time, now stored in gdate
    end

    Game.create(fl_a)                 # Create all Games for current team
  end

  # Update Games and Gamestats tables for any games that have been completed
  # @return [Array[STRING]] Process Messages
  def self.UpdateFromSchedule()
    gs_msgs = [] # Gamestat message
    ignore_on_create = [:gtime, :g_datetime]
    ignore_on_update = [:gtime, :g_datetime, :tv, :game_num, :gdate]

    time = Benchmark.realtime do
      puts "Updating GameStats : #{Date.today.strftime("%F")}"
      scraper = EspnScrape.new
      Team.all.each do |team|
        print "Processing #{team.t_name}..."
        gs_msgs << "Processing #{team.t_name}..."
        cnt = 0
        fl_a  = []
        pastGames = from_array2d(Game::FIELD_NAMES_PG, scraper.getSchedule(team.t_abbr).getPastGames())
        pastGames.each do |pg|
          # puts pg.inspect
          print '.'
          # Check if this boxscore_id has already been processed
          game = Game.find_by("team_id = ? AND boxscore_id = ?" , team.id, pg[:boxscore_id])
          if game.nil?
            # Boxscore not processed
            # Validate that game number and opponent are correct
            game = Game.find_by("team_id = ? AND game_num = ? AND opp_abbr" ,
                                 team.id, pg[:game_num], pg[:opp_abbr])
            if !game.nil?
              ignore_on_update.each { |f| pg.delete(f) }
              game.update(pg)
            else
              ignore_on_create.each { |f| pg.delete(f) }
              # If oppenent or game # are incorrect, delete existing record and replace
              Game.where("team_id = ? AND game_num = ?" , team.id, pg[:game_num]).destroy_all
              Game.create(pg)
            end

            gs_msgs << "\n..Games: #{pg[:t_abbr]}(#{pg[:team_score]}) "\
            "%s #{pg[:opp_abbr]}(#{pg[:opp_score]}) updated."\
            % [pg[:home] ? "vs" : "@"]

            cnt += 1
            if pg[:boxscore_id] > 0
              # Delete any conflicting Gamestat information
              Gamestate.where(boxscore_id: pg[:boxscore_id]).destroy_all

              # Collect boxcore data
              bs = es.getBoxscore(pg[:boxscore_id])
              fl_temp = from_array2d(Gamestat::FIELD_NAMES, (pg[:home] ? bs.getHomeTeamPlayers : bs.getAwayTeamPlayers))

              # Process boxscore data
              fl_temp.each do |fl| #set foreign keys
                fl = Player.setForeignKeys(fl, pg[:boxscore_id], bs)
              end

              # Save processed data for insertion into database
              fl_a << fl_temp
              gs_msgs << "\n..GameStats: Game #{pg[:game_num]} vs #{pg[:opp_abbr]  } saved."
            end
          end
        end
        Gamestat.create(fl_a)
        gs_msgs << " #{team.t_name}...#{cnt} games updated."
      end
    end
    return gs_msgs << "Update completed in #{time} sec"
  end

  # Get Today's Games
  # @param d [Datetime] # A DateTime object
  # @return [ActiveRecord::Game] # Game AR Relation
  def self.gamesToday(d='')
    Game.where(gdate: (Date.today.beginning_of_day..Date.today.end_of_day)).where(:home => true).order("gdate")
  end

  # Get Games By Date
  # @param d [Datetime] # A DateTime object
  # @return [ActiveRecord::Game] # Game AR Relation
  def self.gamesYesterday()
    Game.where(gdate: ((Date.today.yesterday.beginning_of_day)..(Date.today.yesterday.end_of_day))).where(:home => true).order("gdate")
  end



end
