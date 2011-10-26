# == Schema Information
# Schema version: 20110401153720
#
# Table name: tags
#
#  id                 :integer(4)      not null, primary key
#  name           :string(255)
#  created_at   :datetime
#  updated_at  :datetime
#

class Tag < ActiveRecord::Base
  #-------------------------------------------------------------------------------------- ASOCJACJA
  has_many :contexts, :dependent => :destroy
  has_many :photos, :through => :contexts

  #-----------------------------------------------------------------------------------------------------
  #\ą\ę\ł\ć\ń\ś\ó\ź\ż
  tag_regex = /\A[a-zA-Z\u0105\u0119\u0142\u0107\u0144\u015B\u00F3\u017A\u017C\u00F2\d\-]+\z/i

  validates :name, :presence => true, :length => { :within => 3..20 },
                :format => { :with => tag_regex }

  #----------------------------------------------------------------------------------------------------
  scope :by_name, :order => :name

  #----------------------------------------------------------------------------------------------------
  def self.search(search_item)
    if search_item
      search_item.split(" ").map do |name|
        @search = self.where('name LIKE ?', "%#{name}%").limit(10)
      end
    else
      return [nil]
    end
  end

end
