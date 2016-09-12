# # Java Threads
# require 'java'
# require_relative './BoxscoreWorkerJava'
#
# java_import 'java.util.concurrent.FutureTask'
# java_import 'java.util.concurrent.LinkedBlockingQueue'
# java_import 'java.util.concurrent.ThreadPoolExecutor'
# java_import 'java.util.concurrent.TimeUnit'

# Celluloid Threads
require_relative './BoxscoreWorker'

class SeedDB
  # Setup
  def initialize
    @completedGames = []
    @file = nil
    puts
    puts "------ Configuration ---------"
    puts "YEAR: #{YEAR}"
    puts "SEASON_TYPES: #{SEASON_TYPES}"
    puts "SAVE_TO_FILE: #{SAVE_TO_FILE}"
    puts "USE_STORED_DATA: #{USE_STORED_DATA}"
    puts "------------------------------"
  end

  # Use stored CREATE commands to populate DB
  def seed_from_file
    puts "Seeding DB with #{STORED_SEEDS} - (approx. 10mins)"
    [Team, Player, Game, Gamestat].each {|t| t.delete_all}
    require_relative "./#{STORED_SEEDS}"
  end

  # Use HoopScrape to collect live data from the internet
  def seed_from_web
    @file = File.open('db/'+STORED_SEEDS, "w") if SAVE_TO_FILE # Destination file for saving
    seed_teams                # HoopScrape::NbaTeamList => Teams
    Team.all.each do |team|
      process_schedules(team) # HoopScrape::NbaSchedule => Games
      process_roster(team)    # HoopScrape::NbaRoster   => Players
    end
    seed_gamestats            # HoopScrape::NbaBoxscore => Gamestats
    @file.close if SAVE_TO_FILE
  end

  # Populate Teams Table with NBA League data
  def seed_teams
    print "\nSeeding Teams..."
    if(Team.all.count == 0)                     # Skip already populated data
      fl_a = HoopScrape.teamList(:to_hashes)[]  # Field List Array => [Dictionary]
      Team.create(fl_a)                         # Create all Teams
      @file.puts "Team.create(#{fl_a})" if SAVE_TO_FILE  # Save Create command
    end
    puts "#{Team.all.count}...Done."                            # Confirm Team count
  end


  # Populate Games Table with Team Schedule Data
  def process_schedules(team)
    # @completedGames = Game.all.map{|g| g.boxscore_id}
    # return unless @completedGames.empty?
    print "-- #{team.name} Games..."
    SEASON_TYPES.each { |season_type|                         # Process configured season types
      # Skip already populated data
      if(Game.where("team_id = ? AND season_type = ?", team.id, season_type).size == 0)
        t_schedule = HoopScrape.schedule(team.abbr, season: season_type, format: :to_hashes, year: YEAR)
        fl_a = Game.refreshSchedule(team, t_schedule, season_type)
        @file.puts "Game.create(#{fl_a})" if SAVE_TO_FILE && !fl_a.empty? # Save Crate command
      end
    }
    puts "%i...Done." % [Game.where("team_id = ?", team.id).size]  # Confirm Game count
  end

  # Populate Players Table with Team Roster Data
  def process_roster(team)
    ## Process Team Roster
    if(Player.where("team_id = ?", team.id).size == 0)        # Skip already populated data
      print "-- #{team.name} Players..."
      roster = HoopScrape.roster(team.abbr, format: :to_hashes)
      fl_a = Player.refreshRoster(team, roster.players[])
      @file.puts "Player.create(#{fl_a})" if SAVE_TO_FILE  # Save Create command
      puts "%i...Done." % [Player.where("team_id = ?", team.id).size] # Confirm Player count
    end
  end


  # Populate Gamestats Table
  def seed_gamestats
    ActiveRecord::Base.clear_active_connections!

    ## Process Gamestats - Save boxscore data for completed games
    boxscores = Game.where('boxscore_id > 0').pluck(:boxscore_id).uniq
    out_of    = boxscore.size
    boxscores.each_with_index do |boxscore_id, idx|
      if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?  # Skip already processed Games
        print "-- Gamestats : #{idx} / #{out_of} [#{((idx/out_of.to_f)*100).round}\%]    \r"
        $stdout.flush

        # Celluloid Futures
        supervisor = BoxscoreWorker.supervise_as :mp, boxscore_id
        mp = Celluloid::Actor[:mp]

        markup_future = mp.future :process
        mp.save_to_db_future markup_future
      end
    end
    puts  "-- Gamestats :: 100% !" + " "*30
  end

  # def seed_gamestats_java
  #   ## Process Gamestats - Save boxscore data for completed games
  #   ActiveRecord::Base.clear_active_connections!
  #   tasks = []
  #   executor = getExecutor
  #
  #   Game.where('boxscore_id > 0').limit(200).pluck(:boxscore_id).uniq.each do |boxscore_id|
  #     if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?  # Skip already processed Games
  #       # Java Threads
  #       task = FutureTask.new(BoxscoreWorkerJava.new boxscore_id)
  #       executor.execute(task)
  #       tasks << task
  #     end
  #   end
  #
  #   # Java - Save data from completed threads
  #   out_of = tasks.size
  #   tasks.each_with_index do |t,idx|
  #     Gamestat.create(t.get)
  #     print "-- Gamestats : #{idx} / #{out_of} [#{((idx/out_of.to_f)*100).round}\%]    \r"
  #     $stdout.flush
  #   end
  #   executor.shutdown()
  #   puts  "-- Gamestats :: 100% !" + " "*30
  # end

  def process_boxscore(boxscore_id)
    if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?  # Skip already processed Games
      bs = HoopScrape.boxscore(boxscore_id, :to_hashes)

      fl_a_home = bs.homePlayers[]
      fl_a_away = bs.awayPlayers[]

      # Set Foreign Keys - Used to simplify site navigation
      fl_a_home.each do |fl|
        fl = Player.setForeignKeys(fl, boxscore_id, bs, true, @file)
        fl[:game_num] = Game.getGameNum(fl[:abbr], boxscore_id)
      end
      fl_a_away.each do |fl|
        fl = Player.setForeignKeys(fl, boxscore_id, bs, false, @file)
        fl[:game_num] = Game.getGameNum(fl[:abbr], boxscore_id)
      end
    end
    Gamestat.create(fl_a_away)
    Gamestat.create(fl_a_home)
  end

  def spinner(idx)
    %w(- \ | /)[idx % 4]
  end

  private
  def getExecutor
    ThreadPoolExecutor.new(
    20, # core_pool_treads
    20, # max_pool_threads
    2*60, # keep_alive_time
    TimeUnit::SECONDS,
    LinkedBlockingQueue.new)
  end

end
