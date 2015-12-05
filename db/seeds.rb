# Database Seed :: db:seed or db:setup
require 'benchmark'
require 'espnscrape'
require 'war'
include WAR

time = Benchmark.realtime do
  es = EspnScrape.new()

  print "\nSeeding Teams..."
  tl = es.getTeamList().getTeamList()
  fl_a = from_array2d(Team::FIELD_NAMES, tl) # Field List Array :: [Dictionary]
  Team.create(fl_a)

  puts "#{Team.all.count}...Done."

  gs_c_list = [] # Gamestat Collection List
  Team.all.each do |team|
    print "-- #{team.t_name} Games..."
    s = es.getSchedule(team.t_abbr)
    fl_a = from_array2d(Game::FIELD_NAMES_PG, s.getPastGames)
    s.getPastGames.each { |pg| gs_c_list << pg[10] } # Construct [boxscore_id] for Gamestats population
    fl_a += from_array2d(Game::FIELD_NAMES_FG, s.getFutureGames)

    # Set Foreign Keys
    fl_a.each do |fl|
      print "."
      fl[:team_id] = team.id
      fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
      fl[:gdate] = fl[:g_datetime]    # Utilize Game DateTime as Game Date
      fl.delete(:g_datetime)
      fl.delete(:gtime)               # Eliminate Game Time, now stored in gdate
    end
    Game.create(fl_a)
    puts "%i...Done." % [Game.where("team_id = ?", team.id).size]

    print "-- #{team.t_name} Players..."
    tr = es.getRoster(team.t_abbr)
    fl_a = from_array2d(Player::FIELD_NAMES, tr.getRoster)

    # Set Foreign Keys
    fl_a.each do |fl|
      print "."
      fl[:team_id] = team.id
    end
    Player.create(fl_a)
    puts "%i...Done." % [Player.where("team_id = ?", team.id).size]
  end

  puts "-- Gamestats..."
  gs_c_list.uniq.sort.each do |boxscore_id|
    print "BoxscoreID:" + boxscore_id.to_s + ".."
    if Gamestat.find_by("boxscore_id = ?", boxscore_id).nil?
      print "..NF.."
      bs = es.getBoxscore(boxscore_id)
      fl_a_home = from_array2d(Gamestat::FIELD_NAMES, bs.getHomeTeamPlayers)
      fl_a_away = from_array2d(Gamestat::FIELD_NAMES, bs.getAwayTeamPlayers)

      # Set Foreign Keys
      # print ".home."
      fl_a_home.each do |fl|
        print "."
        fl[:player_id] = Player.getPlayerId(fl[:p_name])
        fl[:boxscore_id] = boxscore_id
        fl[:opp_abbr] = bs.getTid(bs.getAwayTeamName)
        fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
      end
      # print ".away."
      fl_a_away.each do |fl|
        print "."
        fl[:player_id] = Player.getPlayerId(fl[:p_name])
        fl[:boxscore_id] = boxscore_id
        fl[:opp_abbr] = bs.getTid(bs.getHomeTeamName)
        fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
      end
      puts "Done."
    else
      puts "..F..Done."
    end
    Gamestat.create(fl_a_away)
    Gamestat.create(fl_a_home)
  end

end
puts "\nCompleted in #{time} sec"
