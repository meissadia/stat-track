# Database Seed :: db:seed or db:setup
require 'benchmark'
require 'espnscrape'
require_relative './seeds_config'

## Process Data ##
if( @useStoredData )
  puts "Seeding DB with seeds_stored.rb - (approx. 10mins)"
  time = Benchmark.realtime do
    Team.delete_all
    Player.delete_all
    Game.delete_all
    Gamestat.delete_all
    require_relative "./#{@fileName}"
  end
  puts "Completed in #{time} sec."
else
  file = @overwriteStoredData ? File.open('db/'+@fileName, "w") : nil # Destination file for saving
  time = Benchmark.realtime do
    ## Process Team List
    print "\nSeeding Teams..."
    if(Team.all.count == 0)                                     # Skip already populated data
      team_list = EspnScrape.teamList.teamList
      fl_a = EspnScrape.to_hashes(Team::FIELD_NAMES, team_list) # Field List Array => [Dictionary]
      Team.create(fl_a)                                         # Create all Teams
      file.puts "Team.create(#{fl_a})" if @overwriteStoredData  # Save Create command
    end
    puts "#{Team.all.count}...Done."                            # Confirm Team count

    ## Process Team Schedule
    completedGameBoxscores = []                                 # Gamestat Collection List
    Team.all.each do |team|
      print "-- #{team.t_name} Games..."
      @seasonTypes.each { |season_type|                         # Process configured season types
        teamSchedule = EspnScrape.schedule(team.t_abbr, season_type)

        # Collect boxscore ids for Gamestats population
        teamSchedule.getPastGames.each { |pg| completedGameBoxscores << (pg[10].nil? ? 0 : pg[10]) }

        # Skip already populated data
        if(Game.where("team_id = ? AND season_type = ?", team.id, season_type).size == 0)
          fl_a = Game.refreshSchedule(team, teamSchedule, season_type)
          file.puts "Game.create(#{fl_a})" if @overwriteStoredData && !fl_a.empty? # Save Crate command
        end
      }
      puts "%i...Done." % [Game.where("team_id = ?", team.id).size]  # Confirm Game count

      ## Process Team Roster
      print "-- #{team.t_name} Players..."
      if(Player.where("team_id = ?", team.id).size == 0)        # Skip already populated data
        roster = EspnScrape.roster(team.t_abbr)
        fl_a = Player.refreshRoster(team, roster.players)
        file.puts "Player.create(#{fl_a})" if @overwriteStoredData  # Save Create command
      end
      puts "%i...Done." % [Player.where("team_id = ?", team.id).size] # Confirm Player count
    end

    ## Process Gamestats - Save boxscore data for completed games
    print "-- Gamestats..."
    completedGameBoxscores = completedGameBoxscores.reject { |c| c.to_s.nil? || c.to_s.empty? || c == 0 }
    completedGameBoxscores.uniq.each do |boxscore_id|
      print "."
      if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?  # Skip already processed Games
        boxscore = EspnScrape.boxscore(boxscore_id)

        fl_a_home = EspnScrape.to_hashes(Gamestat::FIELD_NAMES, boxscore.homePlayers)
        fl_a_away = EspnScrape.to_hashes(Gamestat::FIELD_NAMES, boxscore.awayPlayers)

        # Set Foreign Keys - Used to simplify site navigation
        fl_a_home.each do |fl|
          fl = Player.setForeignKeys(fl, boxscore_id, boxscore, true, file)
          fl[:game_num] = Game.getGameNum(fl[:t_abbr], boxscore_id)
        end
        fl_a_away.each do |fl|
          fl = Player.setForeignKeys(fl, boxscore_id, boxscore, false, file)
          fl[:game_num] = Game.getGameNum(fl[:t_abbr], boxscore_id)
        end
      end
      Gamestat.create(fl_a_away)
      Gamestat.create(fl_a_home)
      file.puts "Gamestat.create(#{fl_a_away})" if @overwriteStoredData # Save Create command
      file.puts "Gamestat.create(#{fl_a_home})" if @overwriteStoredData # Save Create command
    end
    puts "Done."
    file.close

  end
  puts "\nCompleted in #{time} sec"
end
