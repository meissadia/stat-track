require 'celluloid/current'

class BoxscoreWorker
  include Celluloid

  def initialize(bs=nil)
    @boxscore_id = bs
  end

  def process(boxscore_id=nil)
    boxscore_id ||= @boxscore_id
    bs = HoopScrape.boxscore(boxscore_id, :to_hashes)

    fl_a_home = bs.homePlayers[]
    fl_a_away = bs.awayPlayers[]

    # Set Foreign Keys - Used to simplify site navigation
    fl_a_home.each do |fl|
      fl = Player.setForeignKeys(fl, boxscore_id, bs, true, @file)
      fl[:game_num] = Game.getGameNum(fl[:abbr], boxscore_id)
    end
    fl_a_away.each do |fl|
      fl = Player.setForeignKeys(fl, boxscore_id, bs, false, @file)
      fl[:game_num] = Game.getGameNum(fl[:abbr], boxscore_id)
    end
    ActiveRecord::Base.connection.close
    return fl_a_away + fl_a_home
  end

  def save_to_db(a)
    Gamestat.create(a) unless a.nil?
    ActiveRecord::Base.connection.close
  end

  def save_to_db_future(a)
    Gamestat.create(a.value) unless a.value.nil?
    ActiveRecord::Base.connection.close
  end

  def pool_process(boxscore_id)
    save_to_db(process(boxscore_id))
  end
  
end
