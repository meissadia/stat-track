require 'benchmark'
require 'espnscrape'

class Game < ActiveRecord::Base
  belongs_to :team
  # FIELD_NAMES_PG = [:team, :p_eid, :name, :pos, :min, :fgm, :fga, :tpm, :tpa, :ftm, :fta, :oreb, :dreb, :reb, :ast, :stl, :blk, :tos, :pf, :plus, :pts, :starter]
  # FIELD_NAMES_FG = EspnScrape::FS_SCHEDULE_FUTURE

  # Find the latest completed games
  def self.latestComplete
    Game.where(datetime: Game.latestDate, home: true).order("datetime")
  end

  # Find games on a specified Date
  def self.gamesOnDate(d)
    Game.where(datetime: d, home: true).order("datetime")
  end

  # Find the Date for the latest completed games
  def self.latestDate
    Game.where('boxscore_id > ?', 0).order('datetime desc').limit(1).pluck(:datetime).first
  end

  def self.dateBeforeLatest
    Game.where('boxscore_id > 0 and datetime < ?', Game.latestDate).order('datetime desc').limit(1).pluck(:datetime).first
  end

  # Find the Game # - used during db population
  def self.getGameNum(abbr, boxscore_id)
    g = Game.where("abbr = ? AND boxscore_id = ?", abbr, boxscore_id)
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
    fl_a  = teamSchedule.pastGames[]
    fl_a += teamSchedule.futureGames[]
    # Set Foreign Keys
    # puts "TeamID: #{team.id}"
    fl_a.each do |fl|
      print "."
      # puts "#{fl[:team_id]} vs #{fl[:opponent]}"
      fl[:team_id]      = team.id
      fl[:opponent_id]  = Team.getTeamId(fl[:opponent])
      fl.delete(:date)  # Eliminate date, using :datetime
      fl.delete(:time)  # Eliminate time, using :datetime
      # puts fl
    end

    Game.create(fl_a)                 # Create all Games for current team
    return fl_a
  end

  # Update Games and Gamestats tables for any games that have been completed
  # @return [Array[STRING]] Process Messages
  def self.updateFromSchedule()
    gs_msgs = [] # Gamestat message
    ignore_on_create = [:time, :date]
    ignore_on_update = [:time, :date, :tv, :game_num, :datetime]

    time = Benchmark.realtime do
      puts "Updating GameStats : #{Date.today.strftime("%F")}"
      Team.all.each do |team|
        print "Processing #{team.name}..."
        gs_msgs << "Processing #{team.name}..."
        cnt = 0
        fl_a  = []
        # Update from the last accessible
        pastGames  = EspnScrape.schedule(team.abbr, '', :to_hashes).pastGames[]
        pastGames.each do |pg|
          print '.'
          home_game = pg[:home].eql?('true')

          # Check if this boxscore_id has already been processed
          game = Game.find_by("team_id = ? AND boxscore_id = ?" , team.id, pg[:boxscore_id])
          if game.nil?                                 # Boxscore not processed
            # Set Foreign Keys
            pg[:team_id] = team.id
            pg[:opponent_id] = Team.getTeamId(pg[:opponent])

            # Validate that game number and opponent are correct
            game = Game.find_by("team_id = ? AND game_num = ? AND opponent = ?" ,
                                 team.id, pg[:game_num], pg[:opponent])
            if !game.nil?
              ignore_on_update.each { |f| pg.delete(f) }
              # gs_msgs << "Updating #{team.abbr}, #{pg[:game_num]}, #{pg[:opponent]}"
              game.update(pg)
            else
              # gs_msgs << "Creating #{team.abbr}, #{pg[:game_num]}, #{pg[:opponent]}"
              ignore_on_create.each { |f| pg.delete(f) }
              # If oppenent or game # are incorrect, delete existing record and replace
              Game.where("team_id = ? AND game_num = ?" , team.id, pg[:game_num]).destroy_all
              game = Game.create(pg)
            end

            gs_msgs << "\n..Games: #{pg[:abbr]}(#{pg[:team_score]}) "\
            "%s #{pg[:opponent]}(#{pg[:opp_score]}) updated."\
            % [home_game ? "vs" : "@"]

            cnt += 1
            if pg[:boxscore_id].to_i > 0
              # Delete any conflicting Gamestat information
              Gamestat.where(boxscore_id: pg[:boxscore_id], abbr: pg[:abbr]).destroy_all

              # Collect boxcore data
              bs = EspnScrape.boxscore(pg[:boxscore_id], :to_hashes)
              fl_temp = (home_game ? bs.homePlayers[] : bs.awayPlayers[])

              # Process boxscore data
              fl_temp.each do |fl| #set foreign keys
                fl = Player.setForeignKeys(fl, pg[:boxscore_id], bs, home_game)
              end
              # gs_msgs << "Creating #{fl_temp.size} GameStat records."

              # Save processed data for insertion into database
              fl_a << fl_temp
              gs_msgs << "\n..GameStats: Game #{pg[:game_num]} vs #{pg[:opponent]  } saved."
            end
          end
        end
        Gamestat.create(fl_a)
        gs_msgs << " #{team.name}...#{cnt} games updated."
      end
    end
    return gs_msgs << "Update completed in #{time} sec"
  end

end
