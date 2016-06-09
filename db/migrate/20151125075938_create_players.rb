class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :team, index: true
      # t.references :game, index: true
      t.string  :t_abbr, index: true
      t.integer :p_eid,  index: true
      t.string  :p_name
      t.integer :p_num
      t.string  :pos
      t.integer :age
      t.integer :h_ft
      t.integer :h_in
      t.integer :weight
      t.string  :college
      t.integer :salary
      t.timestamps null: false
    end
  end
end
