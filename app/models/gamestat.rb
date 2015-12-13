class Gamestat < ActiveRecord::Base
  belongs_to :player
  # belongs_to :game

  FIELD_NAMES = [:t_abbr,:game_num,:p_name,:pos,:min,:fgm,:fga,:tpm,:tpa,:ftm,:fta,:oreb,:dreb,:reb,:ast,:stl,:blk,:tos,:pf,:plus,:pts,:starter]

  # GameScore SQL formulaGameScore
  # @returns [String] #GameScore formula
  def self.formulaGameScore
    "(pts + (fgm * 0.4) + (fga * -0.7) + ((fta-ftm) * -0.4) + "\
        "(OREB * 0.7) + (DREB * 0.3) + STL + (AST * 0.7) + (BLK * 0.7) + "\
          "(PF * -0.4) - tos) as gamescore"\
  end

  # Get stat lines for top GameScores
  # @param bs_id [Integer] #Boxscore ID
  # @param lim [Integer] #Number of players to return
  # @param home [Bool] #Limit selection to home team(true), away team(false), all('')
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScores(bs_id=0, lim=1, home='')
    s = "p_name, t_abbr, pts, reb, ast, blk, stl, tos," + Gamestat.formulaGameScore
    home = (home.eql?('') ? "('t','f')" : "(\'#{home}\')")
    Gamestat.select(s).where(:boxscore_id => bs_id, t_home: home).order("gamescore desc").limit(lim)
  end

  # Get top GameScores
  # @param glist [Array[Integer]] # BoxscoreID array
  # @param lim [Integer] # Max number of statlines returned
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScores(glist=[], lim=5)
    s = "p_name, player_id, boxscore_id, t_abbr, pts, reb, ast, blk, stl, tos," + Gamestat.formulaGameScore
    Gamestat.select(s).where(boxscore_id: glist).order("gamescore desc").limit(lim)
  end
end
