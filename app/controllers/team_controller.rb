class TeamController < ApplicationController
  def index
    @teams = Team.all
    @alt_bg = 0
  end

  def by_team
    redirect_to "/team/%s" % [Team.getTeamId(params[:abbr])]
  end

  def show
    @alt_bg = 0
    @team = Team.find(params[:id])
    @roster = Player.where(:team_id => @team.id)

    @next_game = Game.find_by(["team_id = ? and boxscore_id = 0", @team.id])

    @last10_games = Game.where("team_id = ? and boxscore_id > 0", @team.id ).order("datetime desc").limit(10)
    @next10_games = Game.where(:team_id => @team.id).where("boxscore_id = 0").limit(10)

    @rank = league_rank(@team.abbr)
    last_game = Game.where("team_id = ? and boxscore_id > 0 and season_type = 2", @team.id ).order("datetime desc").first
    @wins = last_game.wins.to_i
    @losses = last_game.losses.to_i
    @win_pct = (@wins.to_f / (@wins + @losses)).round(2)

    @team_logo = StatTrack::Application.config.logos[@team.name]
    @next_logo = @next_game.nil? ? nil : StatTrack::Application.config.logos[Team.getTeamName(@next_game.opp_id)]

    @team_best = Gamestat.topGameScoresTeamSeason(@team.abbr)
  end

  def schedule
    @alt_bg = 0
    @team = Team.find(params[:id])
    @past_games = Game.where(:team_id => @team.id).where("boxscore_id > 0")
    @future_games = Game.where(:team_id => @team.id).where(:boxscore_id => '0')
    @team_logo = StatTrack::Application.config.logos[@team.name]
  end



  private
    def league_rank(abbr="")
      t_rank = []
      s = "abbr, wins, losses"
      @records = Game.select(s).where("boxscore_id > 0 and season_type = 2").group(:abbr).order(:wins)
      @records.each do |record|
        w_pct = record.wins.to_f / (record.wins + record.losses)
        t_rank << [w_pct.round(2), record.abbr]
      end
      t_rank.sort!.reverse!
      t_rank = t_rank.index{|pct, team| team == abbr} + 1
    end
end
