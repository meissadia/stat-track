class GameController < ApplicationController
  def show
    @alt_bg = 0
    @game = Game.find_by("home = 't' and boxscore_id = ?", params[:boxscore_id])
    if(@game.nil?)
      redirect_to '/'
      return nil
    end

    s = "Gamestats.*, " + Gamestat.formulaGameScore
    @home_stats = Gamestat.select(s).where("abbr = ? and boxscore_id = ?", @game.abbr, @game.boxscore_id)
    @away_stats = Gamestat.select(s).where("abbr = ? and boxscore_id = ?", @game.opponent, @game.boxscore_id)

    @games_best = Gamestat.topGameScores([@game.boxscore_id])
    @home_best = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.abbr)
    @away_best = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.opponent)

    @home_name = Team.getTeamName(@game.team_id)
    @away_name = Team.getTeamName(@game.opponent_id)
    @home_logo = StatTrack::Application.config.logos[@home_name]
    @away_logo = StatTrack::Application.config.logos[@away_name]
  end

  private
  def games_params
    params.require(:games).allow(:abbr, :boxscore_id)
  end

end
