class GameController < ApplicationController
  def show
    @alt_bg = 0
    @game = Game.find_by("home = 't' and boxscore_id = ?", params[:boxscore_id])
    if(@game.nil?)
      redirect_to '/'
      return nil
    end

    # Best Performances (both teams)
    @games_best = Gamestat.topGameScores([@game.boxscore_id])

    # Prepare Query: All columns + Calculate game score
    s = "Gamestats.*, " + Gamestat.formulaGameScore

    # Home Team
    @home_name  = Team.getTeamName(@game.team_id)
    @home_stats = Gamestat.select(s).where("abbr = ? and boxscore_id = ?", @game.abbr, @game.boxscore_id)
    @home_best  = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.abbr)

    # Away Team
    @away_name  = Team.getTeamName(@game.opponent_id)
    @away_stats = Gamestat.select(s).where("abbr = ? and boxscore_id = ?", @game.opponent, @game.boxscore_id)
    @away_best  = Gamestat.topGameScoresTeam(@game.boxscore_id, 5, @game.opponent)
  end

  private
  def games_params
    params.require(:games).allow(:abbr, :boxscore_id)
  end

end
