class PlayerController < ApplicationController
  def index
    @players = Player.where("p_name != ''").order(:p_name)
    @alt_bg = 0
  end

  def show
    @player = Player.find(player_params[:id])
    if @player.nil?
      render players_path
    end
    @alt_bg = 0
    @stats = Gamestat.where("p_name = \"#{@player.p_name}\"")

    @p_maxs_cols = ["min"] << "pts" << "ast" << "reb" << "stl" << "blk" << "tos"
    @p_maxs_cols << "(fgm/fga) as fgp" << "(ftm/fta) as ftp" << "(tpm/tpa) as tpp" << "plus" << "pf"
    @p_maxs = @player.select_max_stats(@p_maxs_cols, {:float_div => true, :decimals => 2, :round_f => ["fgp","ftp","tpp"]})
  end


  private
  def player_params
    params.permit(:id)
  end
end
