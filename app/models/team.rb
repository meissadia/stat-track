class Team < ActiveRecord::Base
  has_many :games
  has_many :players
  # has_many :gamestats, through: [:players, :games]
  FIELD_NAMES = [:t_abbr,:t_name,:division,:conference]

  # Derive Team ID from Team Abbreviation
  # @param s [String] #Team Abbreviation
  # @return [Integer] # Team ID
  def self.getTeamId(s="")
    t = Team.find_by("t_abbr = ?", s.to_s.upcase)
    return (!t.nil? ? t.id : nil)
  end

  # Derive Team Abbr from Team ID
  # @param i [Integer] #Team ID
  # @return [String] # Team Abbr
  def self.getTeamAbbr(i)
    t = Team.find(i)
    return (!t.nil? ? t.t_abbr : nil)
  end

end
