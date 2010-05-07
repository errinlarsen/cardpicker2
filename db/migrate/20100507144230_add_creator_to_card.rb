class AddCreatorToCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :creator_id, :integer
  end

  def self.down
    remove_column :cards, :creator_id
  end
end
