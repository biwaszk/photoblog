class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    # w tabeli users do kolumny email dodaaj constraint unique
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
  end
end
