class TeamController < ApplicationController
  before_action :initialize_common_data, except: [:by_team]

  def index
    @teams = Team.all
  end

  def by_team
    redirect_to "/team/%s" % [Team.getTeamId(params[:abbr])]
  end

  def show
    # Roster
    @roster = Player.where(:team_id => @team.id)

    # Next Game Info
    @next_game = Game.find_by(["team_id = ? and boxscore_id = 0", @team.id])

    # Prev 10 / Next 10
    @last10_games = Game.where("team_id = ? and boxscore_id > 0", @team.id ).order("datetime desc").limit(10)
    @next10_games = Game.where(:team_id => @team.id).where("boxscore_id = 0").limit(10)

    # Team Result Info
    last_game = Game.where("team_id = ? and boxscore_id > 0 and season_type = ?", @team.id, current_season_type ).order("datetime desc").first
    @rank     = league_rank(@team.abbr)
    @wins     = last_game.wins.to_i rescue 0
    @losses   = last_game.losses.to_i rescue 0
    @win_pct  = (@wins + @losses) > 0 ? (@wins.to_f / (@wins + @losses)).round(2) : 0.0

    # Top 5
    @team_best = Gamestat.topGameScoresTeamSeason(@team.abbr)
  end

  def schedule
    @past_games   = Game.where(:team_id => @team.id).where("boxscore_id > 0").order('season_type ASC,game_num ASC')
    @future_games = Game.where(:team_id => @team.id).where(:boxscore_id => '0')
  end

  private
    def initialize_common_data
      @alt_bg = 0
      @team   = Team.find(params[:id])
    end

    def league_rank(abbr="")
      t_rank = []
      s = "abbr, wins, losses"
      @records = Game.select(s).where("boxscore_id > 0 and season_type = ?", current_season_type).group(:abbr).order(:wins)
      @records.each do |record|
        w_pct = record.wins.to_f / (record.wins + record.losses)
        t_rank << [w_pct.round(2), record.abbr]
      end
      t_rank.sort!.reverse!
      t_rank = t_rank.index{|pct, team| team == abbr} + 1 rescue 0
    end
end
