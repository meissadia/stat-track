class Player < ActiveRecord::Base
  belongs_to :team
  # belongs_to :game
  has_many :gamestats

  FIELD_NAMES = [:t_abbr,:p_num,:p_name,:pos,:age,:h_ft,:h_in,:weight,:college,:salary]

  # Derive Player ID from Team Abbreviation
  def self.getPlayerId(s="")
    t = Player.find_by("p_name = ? ", s.to_s)
    return (!t.nil? ? t.id : nil)
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
  def previousPlayer
    if self.id == 1
      return nil
    else
      return self.id - 1
    end
  end

  # Get next PlayerID
  def nextPlayer
    if self.id == Player.all.count
      return nil
    else
      return self.id + 1
    end
  end

end
