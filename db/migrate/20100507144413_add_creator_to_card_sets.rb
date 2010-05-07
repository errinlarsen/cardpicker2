class AddCreatorToCardSets < ActiveRecord::Migration
  def self.up
    add_column :card_sets, :creator_id, :integer
  end

  def self.down
    remove_column :card_sets, :creator_id
  end
end
