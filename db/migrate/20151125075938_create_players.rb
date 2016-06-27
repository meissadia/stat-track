class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :team, index: true
      t.string  :abbr, index: true
      t.integer :eid,  index: true
      t.string  :name
      t.integer :jersey
      t.string  :position
      t.integer :age
      t.integer :height_ft
      t.integer :height_in
      t.integer :weight
      t.string  :college
      t.integer :salary
      t.timestamps null: false
    end
  end
end
