class GameController < ApplicationController
  # def show_team
  #   @alt_bg = 0
  #   @game = Game.find_by("home = 't' and boxscore_id = ?", params[:boxscore_id])
  #   @home_stats = Gamestat.where("t_abbr = ? and boxscore_id = ?", @game.t_abbr, @game.boxscore_id)
  #   @away_stats = Gamestat.where("t_abbr = ? and boxscore_id = ?", @game.opp_abbr, @game.boxscore_id)
  #   render 'show'
  # end

  def show
    @alt_bg = 0
    @game = Game.find_by("home = 't' and boxscore_id = ?", params[:boxscore_id])
    s = "Gamestats.*, " + Gamestat.formulaGameScore
    @home_stats = Gamestat.select(s).where("t_abbr = ? and boxscore_id = ?", @game.t_abbr, @game.boxscore_id)
    @away_stats = Gamestat.select(s).where("t_abbr = ? and boxscore_id = ?", @game.opp_abbr, @game.boxscore_id)

    s = "p_name, t_abbr, pts, reb, ast, blk, stl, tos," + Gamestat.formulaGameScore
    @home_top = Gamestat.select(s).where(:boxscore_id => @game.boxscore_id, :t_abbr => @game.t_abbr).order("gamescore desc").limit(2)
    @away_top = Gamestat.select(s).where(:boxscore_id => @game.boxscore_id, :t_abbr => @game.opp_abbr).order("gamescore desc").limit(2)
  end

  private
  def games_params
    params.require(:games).allow(:t_abbr, :boxscore_id)
  end

end
