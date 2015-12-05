class CreateDbSettings < ActiveRecord::Migration
  def change
    create_table :db_settings do |t|
      t.text :user
      t.text :db_name
      t.text :db_user
      t.text :db_password
      t.boolean :start_fresh
      t.boolean :show_statements
      t.boolean :auto_populate_tables
      t.boolean :auto_populate_teams
      t.boolean :auto_populate_rosters
      t.boolean :auto_populate_schedules
      t.boolean :auto_populate_gamestats
      t.boolean :auto_populate_lotto
      t.boolean :auto_populate_draft

      t.timestamps null: false
    end
  end
end
