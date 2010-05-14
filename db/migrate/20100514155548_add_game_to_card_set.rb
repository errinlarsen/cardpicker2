class AddGameToCardSet < ActiveRecord::Migration
  def self.up
    add_column :card_sets, :game, :string
  end

  def self.down
    remove_column :card_sets, :game
  end
end
