class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :t_abbr, index: true
      t.string :t_name
      t.string :city
      t.string :division
      t.string :conference

      t.timestamps null: false
    end
  end
end
