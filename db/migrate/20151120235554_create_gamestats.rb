class CreateGamestats < ActiveRecord::Migration
  def change
    create_table :gamestats do |t|
      t.references :player,   index: true
      t.integer :boxscore_id, index: true
      t.string  :t_abbr,      index: true
      t.integer :opp_id,      index: true
      t.string  :opp_abbr,    index: true
      t.integer :game_num
      t.string  :p_name
      t.integer :p_eid
      t.string  :pos
      t.integer :min
      t.integer :fgm
      t.integer :fga
      t.integer :tpm
      t.integer :tpa
      t.integer :ftm
      t.integer :fta
      t.integer :oreb
      t.integer :dreb
      t.integer :reb
      t.integer :ast
      t.integer :stl
      t.integer :blk
      t.integer :tos
      t.integer :pf
      t.integer :plus
      t.integer :pts
      t.boolean :starter

      t.timestamps null: false
    end
  end
end
