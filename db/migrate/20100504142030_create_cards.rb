class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.string :game
      t.string :expansion
      t.string :name
      t.string :card_type
      t.string :cost
      t.text :card_text

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
