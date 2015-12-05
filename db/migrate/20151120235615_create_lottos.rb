class CreateLottos < ActiveRecord::Migration
  def change
    create_table :lottos do |t|
      t.integer :rank
      t.integer :odds

      t.timestamps null: false
    end
  end
end
