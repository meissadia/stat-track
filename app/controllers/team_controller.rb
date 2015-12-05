class TeamController < ApplicationController
  def index
    @teams = Team.all
    @alt_bg = 0
  end

  def by_team
    redirect_to "/team/%s" % [Team.getTeamId(params[:t_abbr])]
  end

  def show
    @alt_bg = 0
    @team = Team.find(params[:id])
    @roster = Player.where(:team_id => @team.id)

    @next_game = Game.find_by(["team_id = ? and boxscore_id = 0", @team.id])

    @last10_games = Game.where("team_id = ? and boxscore_id > 0", @team.id ).order("game_num desc").limit(10)

    @wins = @last10_games.first.wins.to_i
    @losses = @last10_games.first.losses.to_i
    @win_pct = (@wins.to_f / (@wins + @losses)).round(2)

    @next10_games = Game.where(:team_id => @team.id).where("boxscore_id = 0").limit(10)
    @rank = rank(@team.t_abbr)
  end

  def schedule
    @alt_bg = 0
    @team = Team.find(params[:id])
    @past_games = Game.where(:team_id => @team.id).where("boxscore_id > 0")
    @future_games = Game.where(:team_id => @team.id).where(:boxscore_id => '0')
  end



  private
    def rank(abbr="")
      t_rank = []
      s = "t_abbr, wins, losses"
      @records = Game.select(s).where("boxscore_id > 0").group(:t_abbr).order(:wins)
      @records.each do |record|
        w_pct = record.wins.to_f / (record.wins + record.losses)
        t_rank << [w_pct.round(2), record.t_abbr]
      end
      t_rank.sort!.reverse!
      t_rank = t_rank.index{|pct, team| team == abbr} + 1
    end
end
