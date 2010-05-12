class AddCustomToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :custom, :boolean
    add_column :card_sets, :custom, :boolean
  end

  def self.down
    remove_column :cards, :custom
    remove_column :card_sets, :custom
  end
end
