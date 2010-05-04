class CreateCardSets < ActiveRecord::Migration
  def self.up
    create_table :card_sets do |t|
      t.string :name
      t.string :set_type
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :card_sets
  end
end
