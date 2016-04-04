class CreateGamePlayerMpr < ActiveRecord::Migration
  def change
    create_table :mprs do |t|
      t.references :player, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.float :mpr, default: 0
    end
  end
end
