class HomepageController < ApplicationController
  def index
    @logos = StatTrack::Application.config.logos
    @background = ''
    @ranks_west = Team.rankings_conf('W')
    @ranks_east = Team.rankings_conf('E')
    @r_cnt = 0
    @games = Game.gamesToday.in_groups(2, false)
    @results = Game.gamesYesterday.in_groups(2, false)

    # Show best of Today.  If there are no completed games for today,
    # show best of Yesterday.
    game_list = []
    @games[0].each {|x| game_list << x.boxscore_id}
    @games[1].each {|x| game_list << x.boxscore_id}
    if !game_list.any? {|x| x > 0}
      game_list = []
      @results[0].each {|x| game_list << x.boxscore_id}
      @results[1].each {|x| game_list << x.boxscore_id}
    end
    @todays_best = Gamestat.topGameScores(game_list)
    @todays_best.each do |p|
      p.bg = @logos[Team.getTeamName(Team.getTeamId(p.t_abbr))]
    end
  end

end
