class CreateDraftPicks < ActiveRecord::Migration
  def change
    create_table :draft_picks do |t|
      t.integer :year
      t.integer :round
      t.integer :pick
      t.string :team_id
      t.string :pname
      t.string :college

      t.timestamps null: false
    end
  end
end
