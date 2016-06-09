class Gamestat < ActiveRecord::Base
  belongs_to :player
  # belongs_to :game

  # FIELD_NAMES = EspnScrape::FS_BOXSCORE

  # GameScore SQL single game
  # @return [String] #GameScore formula
  def self.formulaGameScore
    "(pts + (fgm * 0.4) + (fga * -0.7) + ((fta-ftm) * -0.4) + "\
        "(OREB * 0.7) + (DREB * 0.3) + STL + (AST * 0.7) + (BLK * 0.7) + "\
          "(PF * -0.4) - tos) as gamescore"
  end

  # GameScore SQL for Season
  # @return [String] #GameScore formula
  def self.formulaGameScoreSeason
    "ROUND((SUM(pts) + (SUM(fgm) * 0.4) + (SUM(fga) * -0.7) + ((SUM(fta)-SUM(ftm)) * -0.4) + "\
       "(SUM(OREB) * 0.7) + (SUM(DREB) * 0.3) + SUM(STL) + (SUM(AST) * 0.7) + (SUM(BLK) * 0.7) + "\
       "(SUM(PF) * -0.4) - SUM(tos))/count(*),2) as gamescore"
  end

  # Efficiency SQL for Season
  # @return [String] # Efficiency formula
  def self.formulaEfficiencySeason
    "ROUND(((SUM(pts) + SUM(reb) + SUM(ast) + SUM(stl) + SUM(blk)) - ((SUM(fga) - SUM(fgm)) + ((SUM(fta) - SUM(ftm))*1.0) + SUM(tos)))/count(*),2) as eff"
  end

  # Points/Game SQL
  # @return [String] # Points/Game formula
  def self.formulaPtsSeason
    "ROUND(AVG(pts),2) as apts"
  end

  # Asists/Game SQL
  # @return [String] # Ast/Game formula
  def self.formulaAstSeason
    "ROUND(AVG(ast),2) as aast"
  end

  # Rebounds/Game SQL
  # @return [String] # REB/Game formula
  def self.formulaRebSeason
    "ROUND(AVG(reb),2) as areb"
  end

  # Blocks/Game SQL
  # @return [String] # BLK/Game formula
  def self.formulaBlkSeason
    "ROUND(AVG(blk),2) as ablk"
  end

  # Steals/Game SQL
  # @return [String] # Stl/Game formula
  def self.formulaStlSeason
    "ROUND(AVG(stl),2) as astl"
  end

  # Field Goal %/Game SQL
  # @return [String] # FG %/Game formula
  def self.formulaFgpSeason
    "ROUND((SUM(fgm)*1.0)/SUM(fga),2) as afgp"
  end

  # 3 Point %/Game SQL
  # @return [String] # TP %/Game formula
  def self.formulaTppSeason
    "ROUND((SUM(tpm)*1.0)/SUM(tpa),2) as atpp"
  end

  # Free Throw %/Game SQL
  # @return [String] # FT %/Game formula
  def self.formulaFtpSeason
    "ROUND((SUM(ftm)*1.0)/SUM(fta),2) as aftp"
  end

  # Turnovers/Game SQL
  # @return [String] # TOs/Game formula
  def self.formulaTosSeason
    "ROUND(AVG(tos),2) as atos"
  end

  # Minutes/Game SQL
  # @return [String] # Mins/Game formula
  def self.formulaMinSeason
    "ROUND(AVG(min),2) as amin"
  end

  # Get top GameScores for a single team, single game
  # @param bs_id [Integer] #Boxscore ID
  # @param lim [Integer] #Number of players to return
  # @param home [Bool] #Limit selection to home team(true), away team(false)
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScoresTeam(bs_id=0, lim=1, team='')
    s = "p_name, player_id, boxscore_id, t_abbr, pts, reb, ast, blk, stl, tos," + Gamestat.formulaGameScore
    s << ', "" as bg'
    Gamestat.select(s).where(:boxscore_id => bs_id, :t_abbr => team).order("gamescore desc").limit(lim)
  end

  # Get top GameScores
  # @param glist [Array[Integer]] # BoxscoreID array
  # @param lim [Integer] # Max number of statlines returned
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScores(glist=[], lim=5, home='')
    s = "p_name, player_id, boxscore_id, t_abbr, pts, reb, ast, blk, stl, tos," + Gamestat.formulaGameScore
    s << ', "" as bg'
    Gamestat.select(s).where(boxscore_id: glist).order("gamescore desc").limit(lim)
  end

  # Get top average GameScores for a single team
  # @param team [String] # Team Abbreviation
  # @param lim [Integer] # Max number of statlines returned
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScoresTeamSeason(team, lim=5)
    s = "p_name, player_id, t_abbr,"
    s << Gamestat.formulaPtsSeason + ','
    s << Gamestat.formulaRebSeason + ','
    s << Gamestat.formulaAstSeason + ','
    s << Gamestat.formulaBlkSeason + ','
    s << Gamestat.formulaStlSeason + ','
    s << Gamestat.formulaStlSeason + ','
    s << Gamestat.formulaTosSeason + ','
    s << Gamestat.formulaTosSeason + ','
    s << Gamestat.formulaGameScoreSeason
    Gamestat.select(s).where(:t_abbr => team).group(:player_id).order("gamescore desc").limit(lim)
  end
end
