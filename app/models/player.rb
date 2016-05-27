class Player < ActiveRecord::Base
  belongs_to :team
  # belongs_to :game
  has_many :gamestats

  FIELD_NAMES = EspnScrape::FS_ROSTER

  # Derive Player ID from Team Abbreviation
  def self.getPlayerId(s="")
    t = Player.find_by("p_name = ? ", s.to_s)
    return (!t.nil? ? t.id : nil)
  end

  # Delete existing Roster data and repopulate
  def self.refreshRoster(team, roster)
    Player.where(team_id: team.id).destroy_all
    fl_a = from_array2d(Player::FIELD_NAMES, roster)
    # Set Foreign Keys
    fl_a.each do |fl|
      print "."
      fl[:team_id] = team.id
    end

    Player.create(fl_a)               # Create all Players for current team
  end

  # Set Foreign Keys and clean up some data
  def self.setForeignKeys(fl, boxscore_id, boxscore, home)
    currPlayer = Player.find_by("p_eid = ? ", fl[:p_eid])
    if currPlayer.nil?
      Player.createFromEspn(fl[:p_eid], fl[:t_abbr])
      currPlayer = Player.find_by("p_eid = ? ", fl[:p_eid])
    end
    if(!currPlayer.nil?)
      fl[:player_id] = currPlayer.id
      fl[:p_name] = currPlayer.p_name
    end

    fl[:boxscore_id] = boxscore_id
    team_name = home ? boxscore.getAwayTeamName : boxscore.getHomeTeamName
    fl[:opp_abbr] = boxscore.getTid(team_name)
    fl[:opp_id] = Team.getTeamId(fl[:opp_abbr])
    return fl
  end

  def self.createFromEspn(p_eid, t_abbr="")
    # puts "Creating Player: " + p_eid.to_s + ", team: " + t_abbr
    player = EspnScrape.getPlayer(p_eid)
    if (!player.nil?)
      new_player = {
        :p_name => player.name,
        :pos => player.position,
        :age => player.age,
        :h_ft => player.h_ft,
        :h_in => player.h_in,
        :college => player.college,
        :weight => player.weight,
        :p_eid => p_eid,
        :t_abbr => t_abbr
      }
      Player.create(new_player)
    end
  end

  # Select the MAX value for the given columns
  # @param columns [Array[String]] # Column Names
  # @return [ActiveRecord::Gamestat] # Gamestat row of MAX values
  # @note
  def select_max_stats(columns=[], options={})
    maxs = [] # Processed fields
    if columns.empty?
      columns = Gamestat.column_names
    end
    columns.each { |c|
      res = ""
      col, aka = c.split(' as ')  # Split into ColumnName, ColumnAlias
      res = "MAX(#{col})"
      if aka.nil? # Non-Aliased Columns
        res = options[:round_f].include?(col) ? "ROUND(#{res},#{options[:decimals]})" : res  # Round floats
        res += " as #{col}"
      else        # Aliased Columns
        res = options[:round_f].include?(aka) ? "ROUND(#{res},#{options[:decimals]})" : res  # Round floats
        res += " as #{aka}"
      end
      maxs << (options[:float_div] ? res.gsub('/','*1.0/') : res)  # Force float division | Store processed field
    }
    Gamestat.select(maxs.join(',')).find_by_player_id(self.id)
  end

  # Get previous PlayerID
  # @return [Integer] Player ID
  def previousPlayer
    if self.id == 1
      return nil
    else
      return self.id - 1
    end
  end

  # Get next PlayerID
  # @return [Integer] Player ID
  def nextPlayer
    if self.id == Player.all.count
      return nil
    else
      return self.id + 1
    end
  end

end
