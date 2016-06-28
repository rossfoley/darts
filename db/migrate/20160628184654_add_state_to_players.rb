class AddStateToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :state, :integer
  end
end
