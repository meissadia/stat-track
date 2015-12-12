class HomepageController < ApplicationController
  def index
    @ranks_west = Team.rankings_conf('W')
    @ranks_east = Team.rankings_conf('E')
    @r_cnt = 0
    @games = Game.gamesToday.in_groups(2, false)
  end

end
