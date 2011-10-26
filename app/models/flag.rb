# == Schema Information
# Schema version: 20110401162835
#
# Table name: flags
#
#  id                   :integer(4)      not null, primary key
#  flag_name      :string(255)
#  flag_value      :boolean(1)     default => false
#  created_at     :datetime
#  updated_at    :datetime
#

class Flag < ActiveRecord::Base
  #----------------------------------------------------------------------------------------------------
  attr_accessible :flag_name, :flag_value

  #----------------------------------------------------------------------------------------------------
  validates :flag_name, :presence => true,
                                  :length => { :within => 3..20 },
                                  :uniqueness => { :case_sensitive =>false }

  #------------------------------------------------------------------------------------- TWORZENIE
  def self.assign_flag(f_name,  f_value)
    self.create(:flag_name => f_name, :flag_value => f_value)
  end

  #------------------------------------------------------------------------------------------ ZMIANA
  def self.change_flag(f_name, f_value)
    self.connection.update("UPDATE flags SET flag_value=#{f_value}, updated_at='#{Time.now.to_formatted_s(:db)}' WHERE flag_name='#{f_name}'")
  end

  #------------------------------------------------------------------------------------------ ODCZYT
  def self.return_flag_value(f_name)
    self.find_by_flag_name(f_name).flag_value
  end

  #-------------------------------------------------------------------------------------- USOWANIE
  def self.trash_flag_by_name(f_name)
    self.find_by_flag_name(f_name).destroy
  end

end
