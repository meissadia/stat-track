# used to call java code
require 'java'

# 'java_import' is used to import java classes
java_import 'java.util.concurrent.Callable'

class BoxscoreWorkerJava
  include Callable

  def initialize(bs)
    @boxscore_id = bs
  end

  def call
    boxscore_id = @boxscore_id
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
    fl_a_away + fl_a_home
  end

end
