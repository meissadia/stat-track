class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :team,          index: true
      t.string     :abbr,          index: true
      t.integer    :game_num
      t.boolean    :home
      t.string     :opponent
      t.integer    :opponent_id
      t.boolean    :win,            default: false
      t.integer    :team_score
      t.integer    :opp_score
      t.datetime   :datetime
      t.boolean    :tv,             default: false
      t.integer    :boxscore_id,    index: true, default: 0
      t.integer    :wins
      t.integer    :losses
      t.integer    :season_type
      t.timestamps null: false
    end
  end
end
