class CreateEdges < ActiveRecord::Migration
  def self.up
    create_table :edges do |t|
      t.text :edge_extent
      t.text :edge_intent
      t.integer :concept_id

      t.timestamps
    end
    add_index :edges, :concept_id
  end

  def self.down
    drop_table :edges
  end
end
