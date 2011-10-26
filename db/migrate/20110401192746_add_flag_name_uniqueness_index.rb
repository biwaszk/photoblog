class AddFlagNameUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :flags, :flag_name, :unique => true
  end

  def self.down
    remove_index :flags, :flag_name
  end
end
