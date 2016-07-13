class HomepageController < ApplicationController
  def index
    @games   = [[],[]]
    @results = [[],[]]
    @todays_best = []

    # Latest Completed Regular Season Games
    @games_date = Game.latestDate
    @games = Game.latestComplete.in_groups(2, false)

    # Day Prior to Latest Completed
    @results_date = Game.dateBeforeLatest
    @results = Game.gamesOnDate(@results_date).in_groups(2, false)

    # Show best of Today if any exist.
    # Else, show best of last day with completed games.
    game_list = []
    @games[0].each {|x| game_list << x.boxscore_id}
    @games[1].each {|x| game_list << x.boxscore_id}
    if !game_list.any? {|x| x > 0}
      game_list = []
      @results[0].each {|x| game_list << x.boxscore_id}
      @results[1].each {|x| game_list << x.boxscore_id}
    end
    @todays_best = Gamestat.topGameScores(game_list)

    # League Rankings
    @ranks_west = Team.rankings_conf('W')
    @ranks_east = Team.rankings_conf('E')
  end

end
