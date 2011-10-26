# == Schema Information
# Schema version: 20110401153720
#
# Table name: edges
#
#  id                        :integer(4)      not null, primary key
#  edge_extent        :text
#  edge_intent        :text
#  concept_id         :integer(4)
#  created_at        :datetime
#  updated_at       :datetime
#

class Edge < ActiveRecord::Base
  #-------------------------------------------------------------------------------------- ASOCJACJA
  belongs_to :concept, :class_name => "Lattice", :foreign_key => "concept_id"
  
end
