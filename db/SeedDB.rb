class SeedDB
  # Setup
  def initialize
    @completedGames = []
    @file = nil
  end

  # Use stored CREATE commands to populate DB
  def seed_from_file
    puts "Seeding DB with #{STORED_SEEDS} - (approx. 10mins)"
    [Team, Player, Game, Gamestat].each {|t| t.delete_all}
    require_relative "./#{STORED_SEEDS}"
  end

  # Use EspnScrape to collect live data from the internet
  def seed_from_web
    @file = File.open('db/'+STORED_SEEDS, "w") if SAVE_TO_FILE # Destination file for saving
    seed_teams                # EspnScrape::NbaTeamList => Teams
    Team.all.each do |team|
      process_schedules(team) # EspnScrape::NbaSchedule => Games
      process_roster(team)    # EspnScrape::NbaRoster   => Players
    end
    seed_gamestats            # EspnScrape::NbaBoxscore => Gamestats
    @file.close
  end

  # Populate Teams Table with NBA League data
  def seed_teams
    print "\nSeeding Teams..."
    if(Team.all.count == 0)                     # Skip already populated data
      fl_a = EspnScrape.teamList(:to_hashes)[]  # Field List Array => [Dictionary]
      Team.create(fl_a)                         # Create all Teams
      @file.puts "Team.create(#{fl_a})" if SAVE_TO_FILE  # Save Create command
    end
    puts "#{Team.all.count}...Done."                            # Confirm Team count
  end


  # Populate Games Table with Team Schedule Data
  def process_schedules(team)
    print "-- #{team.name} Games..."
    SEASON_TYPES.each { |season_type|                         # Process configured season types
      t_schedule = EspnScrape.schedule(team.abbr, season_type, :to_hashes)
      # Collect boxscore ids for Gamestats population
      @completedGames += t_schedule.pastGames[].map { |pg| pg[:boxscore_id] }

      # Skip already populated data
      if(Game.where("team_id = ? AND season_type = ?", team.id, season_type).size == 0)
        fl_a = Game.refreshSchedule(team, t_schedule, season_type)
        @file.puts "Game.create(#{fl_a})" if SAVE_TO_FILE && !fl_a.empty? # Save Crate command
      end
    }
    puts "%i...Done." % [Game.where("team_id = ?", team.id).size]  # Confirm Game count
  end

  # Populate Players Table with Team Roster Data
  def process_roster(team)
    ## Process Team Roster
    print "-- #{team.name} Players..."
    if(Player.where("team_id = ?", team.id).size == 0)        # Skip already populated data
      roster = EspnScrape.roster(team.abbr, :to_hashes)
      fl_a = Player.refreshRoster(team, roster.players[])
      @file.puts "Player.create(#{fl_a})" if SAVE_TO_FILE  # Save Create command
    end
    puts "%i...Done." % [Player.where("team_id = ?", team.id).size] # Confirm Player count
  end


  # Populate Gamestats Table
  def seed_gamestats
    ## Process Gamestats - Save boxscore data for completed games
    @completedGames = @completedGames.reject { |c| c.to_s.nil? || c.to_s.empty? || c == 0 }.uniq
    out_of = @completedGames.size
    @completedGames.each_with_index do |boxscore_id, idx|
      print "-- Gamestats : #{idx} / #{out_of} [#{((idx/out_of.to_f)*100).round}\%]    \r"
      $stdout.flush
      if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?  # Skip already processed Games
        bs = EspnScrape.boxscore(boxscore_id, :to_hashes)

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
      @file.puts "Gamestat.create(#{fl_a_away})" if SAVE_TO_FILE # Save Create command
      @file.puts "Gamestat.create(#{fl_a_home})" if SAVE_TO_FILE # Save Create command
    end
    puts  "-- Gamestats :: 100% !" + " "*30
  end

  def spinner(idx)
    %w(- \ | /)[idx % 4]
  end

end
