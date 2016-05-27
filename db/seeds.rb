  # Database Seed :: db:seed or db:setup
require 'benchmark'
require 'espnscrape'
require 'war'
include WAR

time = Benchmark.realtime do
  scraper = EspnScrape.new  # Data Scraper

  print "\nSeeding Teams..."
  if(Team.all.count == 0)                             # Avoid reprocessing already populated data
    team_list = scraper.getTeamList.getTeamList
    fl_a = from_array2d(Team::FIELD_NAMES, team_list) # Field List Array => [Dictionary]
    Team.create(fl_a)                                 # Create all Teams
  end
  puts "#{Team.all.count}...Done."                    # Confirm Team count

  completedGameBoxscores = [] # Gamestat Collection List
  Team.all.each do |team|
    # Process Team Schedule
    print "-- #{team.t_name} Games..."
    teamSchedule = scraper.getSchedule(team.t_abbr)

    # Collect boxscore ids for Gamestats population
    teamSchedule.getPastGames.each { |pg| completedGameBoxscores << (pg[10].nil? ? 0 : pg[10]) }

    # Avoid reprocessing already populated data
    if(Game.where("team_id = ?", team.id).size == 0)
      Game.refreshSchedule(team, teamSchedule)
    end

    # Confirm Game count
    puts "%i...Done." % [Game.where("team_id = ?", team.id).size]

    # Process Team Roster
    print "-- #{team.t_name} Players..."

    # Avoid reprocessing already populated data
    if(Player.where("team_id = ?", team.id).size == 0)
      roster = scraper.getRoster(team.t_abbr)
      Player.refreshRoster(team, roster.getRoster)
    end

    # Confirm Player count
    puts "%i...Done." % [Player.where("team_id = ?", team.id).size]
  end

  # Process Gamestats for all completed games
  puts "-- Gamestats..."
  completedGameBoxscores = completedGameBoxscores.reject {|c| c.to_s.nil? || c.to_s.empty?}
  completedGameBoxscores.uniq.each do |boxscore_id|
    print "."
    # Ignore already processed boxscore_ids
    if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?
      boxscore = scraper.getBoxscore(boxscore_id)

      fl_a_home = from_array2d(Gamestat::FIELD_NAMES, boxscore.getHomeTeamPlayers)
      fl_a_away = from_array2d(Gamestat::FIELD_NAMES, boxscore.getAwayTeamPlayers)

      # Set Foreign Keys
      fl_a_home.each do |fl|
        fl = Player.setForeignKeys(fl, boxscore_id, boxscore, true)
        fl[:game_num] = Game.getGameNum(fl[:t_abbr], boxscore_id)
      end
      fl_a_away.each do |fl|
        fl = Player.setForeignKeys(fl, boxscore_id, boxscore, false)
        fl[:game_num] = Game.getGameNum(fl[:t_abbr], boxscore_id)
      end
    end
    Gamestat.create(fl_a_away)
    Gamestat.create(fl_a_home)
  end
  puts "Done."

end
puts "\nCompleted in #{time} sec"
