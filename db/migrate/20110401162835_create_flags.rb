class CreateFlags < ActiveRecord::Migration
  def self.up
    create_table :flags do |t|
      t.string :flag_name
      t.boolean :flag_value, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :flags
  end
end
