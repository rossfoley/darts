class AddPlayerOrderToGame < ActiveRecord::Migration
  def change
    add_column :games, :player_order, :text
  end
end
