class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :game, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.integer :marks, default: 0

      t.timestamps null: false
    end
  end
end
