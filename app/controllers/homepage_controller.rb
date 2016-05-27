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

    # Update Database
    # @last_update = Gamestat.where("boxscore_id > 0").order("created_at desc").limit(1).first.created_at
    # @last_update2 = Time.now.in_time_zone("UTC")
    #
    # @diff = ((@last_update2 - @last_update) / 1.minute).round
    # if @diff > 30
    #   @updating = "Updating database...please reload"
    #   Thread.new do
    #     @status = Game.UpdateFromSchedule()
    #     ActiveRecord::Base.connection.close
    #   end
    # end
  end

end
