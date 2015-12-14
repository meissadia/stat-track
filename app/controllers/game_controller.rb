class GameController < ApplicationController
  def show
    @alt_bg = 0
    @game = Game.find_by("home = 't' and boxscore_id = ?", params[:boxscore_id])

    s = "Gamestats.*, " + Gamestat.formulaGameScore
    @home_stats = Gamestat.select(s).where("t_abbr = ? and boxscore_id = ?", @game.t_abbr, @game.boxscore_id)
    @away_stats = Gamestat.select(s).where("t_abbr = ? and boxscore_id = ?", @game.opp_abbr, @game.boxscore_id)

    @games_best = Gamestat.topGameScores([@game.boxscore_id])
    @home_best = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.t_abbr)
    @away_best = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.opp_abbr)

    @home_name = Team.getTeamName(@game.team_id)
    @away_name = Team.getTeamName(@game.opp_id)
    @home_logo = StatTrack::Application.config.logos[@home_name]
    @away_logo = StatTrack::Application.config.logos[@away_name]
  end

  private
  def games_params
    params.require(:games).allow(:t_abbr, :boxscore_id)
  end

end
