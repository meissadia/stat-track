require 'benchmark'
require 'espnscrape'

class Game < ActiveRecord::Base
  belongs_to :team
  FIELD_NAMES_PG = EspnScrape::FS_SCHEDULE_PAST
  FIELD_NAMES_FG = EspnScrape::FS_SCHEDULE_FUTURE

  # Find the latest completed games
  def self.latestComplete
    Game.where(gdate: Game.latestDate, home: true).order("gdate")
  end

  # Find games on a specified Date
  def self.gamesOnDate(d)
    Game.where(gdate: d, home: true).order("gdate")
  end

  # Find the Date for the latest completed games
  def self.latestDate
    Game.where('boxscore_id > ?', 0).order('gdate desc').limit(1).pluck(:gdate)
  end

  # Find the Game # - used during db population
  def self.getGameNum(t_abbr, boxscore_id)
    g = Game.where("t_abbr = ? AND boxscore_id = ?", t_abbr, boxscore_id)
    if !g.first.nil?
      return g.first.game_num
    else
      return 0
    end
  end

  # Erase existing Schedule data and replace
  def self.refreshSchedule(team, teamSchedule, season)
    # Delete conflicting Schedule records for this team
    Game.where(team_id: team.id, season_type: season).destroy_all

    fl_a  = EspnScrape.to_hashes(Game::FIELD_NAMES_PG, teamSchedule.getPastGames)
    fl_a += EspnScrape.to_hashes(Game::FIELD_NAMES_FG, teamSchedule.getFutureGames)
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
  def self.updateFromSchedule()
    gs_msgs = [] # Gamestat message
    ignore_on_create = [:gtime, :g_datetime]
    ignore_on_update = [:gtime, :g_datetime, :tv, :game_num, :gdate]

    time = Benchmark.realtime do
      puts "Updating GameStats : #{Date.today.strftime("%F")}"
      Team.all.each do |team|
        print "Processing #{team.t_name}..."
        gs_msgs << "Processing #{team.t_name}..."
        cnt = 0
        fl_a  = []
        # Update from the last accessible
        pastGames  = EspnScrape.to_hashes(Game::FIELD_NAMES_PG, EspnScrape.schedule(team.t_abbr).getPastGames)
        pastGames.each do |pg|
          # puts pg.inspect
          print '.'

          # Check if this boxscore_id has already been processed
          game = Game.find_by("team_id = ? AND boxscore_id = ?" , team.id, pg[:boxscore_id])
          if game.nil?
            # Boxscore not processed

            # Set Foreign Keys
            pg[:team_id] = team.id
            pg[:opp_id] = Team.getTeamId(pg[:opp_abbr])
            pg[:gdate] = pg[:g_datetime]    # Utilize Game DateTime as Game Date

            # Validate that game number and opponent are correct
            game = Game.find_by("team_id = ? AND game_num = ? AND opp_abbr = ?" ,
                                 team.id, pg[:game_num], pg[:opp_abbr])
            if !game.nil?
              ignore_on_update.each { |f| pg.delete(f) }
              # gs_msgs << "Updating #{team.t_abbr}, #{pg[:game_num]}, #{pg[:opp_abbr]}"
              game.update(pg)
            else
              # gs_msgs << "Creating #{team.t_abbr}, #{pg[:game_num]}, #{pg[:opp_abbr]}"
              ignore_on_create.each { |f| pg.delete(f) }
              # If oppenent or game # are incorrect, delete existing record and replace
              Game.where("team_id = ? AND game_num = ?" , team.id, pg[:game_num]).destroy_all
              Game.create(pg)
            end

            gs_msgs << "\n..Games: #{pg[:t_abbr]}(#{pg[:team_score]}) "\
            "%s #{pg[:opp_abbr]}(#{pg[:opp_score]}) updated."\
            % [pg[:home] ? "vs" : "@"]

            cnt += 1
            if pg[:boxscore_id].to_i > 0
              # Delete any conflicting Gamestat information
              Gamestat.where(boxscore_id: pg[:boxscore_id], t_abbr: pg[:t_abbr]).destroy_all

              # Collect boxcore data
              bs = EspnScrape.boxscore(pg[:boxscore_id])
              fl_temp = EspnScrape.to_hashes(Gamestat::FIELD_NAMES, (pg[:home] ? bs.homePlayers : bs.awayPlayers))

              # Process boxscore data
              fl_temp.each do |fl| #set foreign keys
                fl = Player.setForeignKeys(fl, pg[:boxscore_id], bs, pg[:home])
              end
              # gs_msgs << "Creating #{fl_temp.size} GameStat records."

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

end
