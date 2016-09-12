class Gamestat < ActiveRecord::Base
  belongs_to :player
  # belongs_to :game

  # FIELD_NAMES = HoopScrape::FS_BOXSCORE

  # GameScore SQL single game
  # @return [String] #GameScore formula
  def self.formulaGameScore
    "(POINTS + (fgm * 0.4) + (fga * -0.7) + ((fta-ftm) * -0.4) + "\
        "(OREB * 0.7) + (DREB * 0.3) + STEALS + (ASSISTS * 0.7) + (BLOCKS * 0.7) + "\
          "(FOULS * -0.4) - TURNOVERS) as gamescore"
  end

  # GameScore SQL for Season
  # @return [String] #GameScore formula
  def self.formulaGameScoreSeason
    "ROUND((SUM(POINTS) + (SUM(fgm) * 0.4) + (SUM(fga) * -0.7) + ((SUM(fta)-SUM(ftm)) * -0.4) + "\
       "(SUM(OREB) * 0.7) + (SUM(DREB) * 0.3) + SUM(STEALS) + (SUM(ASSISTS) * 0.7) + (SUM(BLOCKS) * 0.7) + "\
       "(SUM(FOULS) * -0.4) - SUM(TURNOVERS))/count(*),2) as gamescore"
  end

  # Efficiency SQL for Season
  # @return [String] # Efficiency formula
  def self.formulaEfficiencySeason
    "ROUND(((SUM(POINTS) + SUM(REBOUNDS) + SUM(ASSISTS) + SUM(STEALS) + SUM(BLOCKS)) - ((SUM(fga) - SUM(fgm)) + ((SUM(fta) - SUM(ftm))*1.0) + SUM(TURNOVERS)))/count(*),2) as eff"
  end

  # Points/Game SQL
  # @return [String] # Points/Game formula
  def self.formulaPtsSeason
    "ROUND(AVG(POINTS),2) as apts"
  end

  # Asists/Game SQL
  # @return [String] # Ast/Game formula
  def self.formulaAstSeason
    "ROUND(AVG(ASSISTS),2) as aast"
  end

  # Rebounds/Game SQL
  # @return [String] # REB/Game formula
  def self.formulaRebSeason
    "ROUND(AVG(REBOUNDS),2) as areb"
  end

  # Blocks/Game SQL
  # @return [String] # BLK/Game formula
  def self.formulaBlkSeason
    "ROUND(AVG(BLOCKS),2) as ablk"
  end

  # Steals/Game SQL
  # @return [String] # Stl/Game formula
  def self.formulaStlSeason
    "ROUND(AVG(STEALS),2) as astl"
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
    "ROUND(AVG(TURNOVERS),2) as atos"
  end

  # Minutes/Game SQL
  # @return [String] # Mins/Game formula
  def self.formulaMinSeason
    "ROUND(AVG(MINUTES),2) as amin"
  end

  # Get top GameScores for a single team, single game
  # @param bs_id [Integer] #Boxscore ID
  # @param lim [Integer] #Number of players to return
  # @param home [Bool] #Limit selection to home team(true), away team(false)
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScoresTeam(bs_id=0, lim=1, abbr='')
    s = "name, player_id, boxscore_id, abbr, POINTS, REBOUNDS, ASSISTS, BLOCKS, STEALS, TURNOVERS," + Gamestat.formulaGameScore
    s << ', "" as bg'
    Gamestat.select(s).where(:boxscore_id => bs_id, :abbr => abbr).order("gamescore desc").limit(lim)
  end

  # Get top GameScores
  # @param glist [Array[Integer]] # BoxscoreID array
  # @param lim [Integer] # Max number of statlines returned
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScores(glist=[], lim=5, home='')
    s = "name, player_id, boxscore_id, abbr, POINTS, REBOUNDS, ASSISTS, BLOCKS, STEALS, TURNOVERS," + Gamestat.formulaGameScore
    s << ', "" as bg'
    Gamestat.select(s).where(boxscore_id: glist).order("gamescore desc").limit(lim)
  end

  # Get top average GameScores for a single team
  # @param team [String] # Team Abbreviation
  # @param lim [Integer] # Max number of statlines returned
  # @return [ActiveRecord::Gamestat] # Gamestat AR Relation
  def self.topGameScoresTeamSeason(abbr, lim=5)
    s = "name, player_id, abbr,"
    s << Gamestat.formulaPtsSeason + ','
    s << Gamestat.formulaRebSeason + ','
    s << Gamestat.formulaAstSeason + ','
    s << Gamestat.formulaBlkSeason + ','
    s << Gamestat.formulaStlSeason + ','
    s << Gamestat.formulaStlSeason + ','
    s << Gamestat.formulaTosSeason + ','
    s << Gamestat.formulaTosSeason + ','
    s << Gamestat.formulaGameScoreSeason
    Gamestat.select(s).where(:abbr => abbr).group(:player_id).order("gamescore desc").limit(lim)
  end
end
