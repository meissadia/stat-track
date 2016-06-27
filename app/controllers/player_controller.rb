class PlayerController < ApplicationController
  def index
    @players = Player.where("name != ''").order(:name)
    @alt_bg = 0
  end

  def show
    @player = Player.find(player_params[:id])
    if @player.nil?
      render players_path
    end
    @alt_bg = 0
    s = "Gamestats.*, " + Gamestat.formulaGameScore
    @stats = Gamestat.select(s).where("name = \"#{@player.name}\"").order("game_num")

    @p_maxs_cols = ["minutes"] << "points" << "assists" << "rebounds" << "steals" << "blocks" << "turnovers"
    @p_maxs_cols << "(fgm/fga) as fgp" << "(ftm/fta) as ftp" << "(tpm/tpa) as tpp" << "plusminus" << "fouls"
    @p_maxs = @player.select_max_stats(@p_maxs_cols, {:float_div => true, :decimals => 2, :round_f => ["fgp","ftp","tpp"]})
    @previous = @player.previousPlayer
    @next = @player.nextPlayer
    @team_name = Team.getTeamName(Team.getTeamId(@player.abbr))
    @team_logo = StatTrack::Application.config.logos[@team_name]
  end


  private
  def player_params
    params.permit(:id)
  end
end
