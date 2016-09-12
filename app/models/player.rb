class Player < ActiveRecord::Base
  belongs_to :team
  # belongs_to :game
  has_many :gamestats

  # Derive Player ID from Team Abbreviation
  def self.getPlayerId(s="")
    t = Player.find_by("name = ? ", s.to_s)
    return (!t.nil? ? t.id : nil)
  end

  # Delete existing Roster data and repopulate
  def self.refreshRoster(team, roster)
    Player.where(team_id: team.id).destroy_all
    fl_a = roster
    # Set Foreign Keys
    fl_a.each do |fl|
      print "."
      fl[:team_id] = team.id
    end

    Player.create(fl_a)               # Create all Players for current team
    return fl_a
  end

  # Set Foreign Keys and clean up some data
  def self.setForeignKeys(fl, boxscore_id, boxscore, home, file=nil)
    currPlayer = Player.find_by("eid = ? ", fl[:eid])
    if currPlayer.nil?
      # puts boxscore_id.to_s
      Player.createFromEspn(fl[:eid], fl[:abbr], file)
      currPlayer = Player.find_by("eid = ? ", fl[:eid])
    end
    if(!currPlayer.nil?)
      fl[:player_id] = currPlayer.id
      fl[:name]      = currPlayer.name
    end

    fl[:boxscore_id] = boxscore_id
    fl[:opponent]    = boxscore.getTid(home ? boxscore.awayName : boxscore.homeName)
    fl[:opponent_id] = Team.getTeamId(fl[:opponent]) || 0
    return fl
  end

  def self.createFromEspn(eid, t_abbr="", file=nil)
    # puts "Creating Player: " + eid.to_s + ", team: " + t_abbr
    player = HoopScrape.player(eid)
    if (!player.name.nil?)
      new_player = {
        :position     => player.position,
        :age          => player.age,
        :height_ft    => player.h_ft,
        :height_in    => player.h_in,
        :eid          => eid,
        :abbr         => t_abbr,
        :name         => player.name,
        :weight       => player.weight,
        :college      => player.college
      }
      Player.create(new_player)
      file.puts "Player.create(#{new_player})" if !file.nil? # Save Create command
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
