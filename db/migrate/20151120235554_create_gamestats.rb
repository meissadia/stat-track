class CreateGamestats < ActiveRecord::Migration
  def change
    create_table :gamestats do |t|
      t.references :player,   index: true
      t.integer :boxscore_id, index: true
      t.string  :abbr,        index: true
      t.integer :opponent_id, index: true
      t.string  :opponent,    index: true
      t.integer :game_num
      t.string  :name
      t.integer :eid
      t.string  :position
      t.integer :minutes
      t.integer :fgm
      t.integer :fga
      t.integer :tpm
      t.integer :tpa
      t.integer :ftm
      t.integer :fta
      t.integer :oreb
      t.integer :dreb
      t.integer :rebounds
      t.integer :assists
      t.integer :steals
      t.integer :blocks
      t.integer :turnovers
      t.integer :fouls
      t.integer :plusminus
      t.integer :points
      t.boolean :starter

      t.timestamps null: false
    end
  end
end
