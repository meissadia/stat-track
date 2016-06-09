class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :team,        index: true
      t.string     :t_abbr,      index: true
      t.integer    :game_num
      t.boolean    :home
      t.string     :opp_abbr
      t.integer    :opp_id
      t.boolean    :win,         default: false
      t.integer    :team_score
      t.integer    :opp_score
      t.datetime   :gdate
      t.boolean    :tv,          default: false
      t.integer    :boxscore_id, index: true, default: 0
      t.integer    :wins
      t.integer    :losses
      t.integer    :season_type

      t.timestamps null: false
    end
  end
end
