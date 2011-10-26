class CreateLattices < ActiveRecord::Migration
  def self.up
    create_table :lattices do |t|
      t.text :concept_extent
      t.text :concept_intent

      t.timestamps
    end
  end

  def self.down
    drop_table :lattices
  end
end
