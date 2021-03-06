class Team < ActiveRecord::Base
  has_many :games
  has_many :players
  # has_many :gamestats, through: [:players, :games]
  # FIELD_NAMES = HoopScrape::FS_TEAM

  # Derive Team ID from Team Abbreviation
  # @param s [String] #Team Abbreviation
  # @return [Integer] # Team ID
  def self.getTeamId(s="")
    t = Team.find_by("abbr = ?", s.to_s.upcase)
    return (!t.nil? ? t.id : nil)
  end

  # Derive Team Abbr from Team ID
  # @param i [Integer] #Team ID
  # @return [String] # Team Abbr
  def self.getTeamAbbr(i)
    t = Team.find(i)
    return (!t.nil? ? t.abbr : nil)
  end

  def self.getTeamName(id)
    if(!id.nil?)
      return Team.find(id).name
    end
    return nil
  end

  # Conference Rankings
  # @param conf_id [Char] #Conference Identifier
  # @return [Array[[Float,]]] # Team Abbr
  def self.rankings_conf(conf_id)
    c_id = conf_id.to_s.upcase
    c_name = (c_id.eql?('W') ? 'Western' : 'Eastern')
    teams = Team.select(:id).where("conference = ?", c_name)
    t_list = []
    t_rank = []
    teams.each { |t| t_list << t.id }
    @records = Game.where(team_id: t_list, season_type: Game.current_season_type).where.not(:boxscore_id => 0).order("datetime desc").group(:team_id)
    @records.each do |record|
      w_pct = record.wins.to_f / (record.wins + record.losses)
      t_rank << [w_pct.round(2), Team.find(record.team_id).name, record]
    end
    t_rank.sort!.reverse!
  end
end
