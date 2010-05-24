class AddRdsOptionsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :rds_options, :text
  end

  def self.down
    remove_column :users, :rds_options
  end
end
