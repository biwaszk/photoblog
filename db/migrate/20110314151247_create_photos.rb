class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :file_name
      t.references :user

      t.timestamps
    end
    add_index :photos, :user_id
    add_index :photos, :file_name, :unique => true
  end

  def self.down
    drop_table :photos
  end
end