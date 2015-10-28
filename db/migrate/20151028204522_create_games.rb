class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :score
      t.integer :winner_id
      t.integer :loser_id
      t.boolean :finished, default: false

      t.timestamps null: false
    end
  end
end
