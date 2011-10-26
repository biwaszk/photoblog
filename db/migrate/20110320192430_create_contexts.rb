class CreateContexts < ActiveRecord::Migration
  def self.up
    create_table :contexts do |t|
      t.references :photo
      t.references :tag

      t.timestamps
    end
    add_index :contexts, :photo_id
    add_index :contexts, :tag_id
    add_index :contexts, [:photo_id, :tag_id], :unique => true
  end

  def self.down
    drop_table :contexts
  end
end
