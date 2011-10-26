# == Schema Information
# Schema version: 20110401153720
#
# Table name: photos
#
#  id                  :integer(4)      not null, primary key
#  file_name      :string(255)
#  user_id         :integer(4)
#  created_at    :datetime
#  updated_at   :datetime
#

class Photo < ActiveRecord::Base
  #-------------------------------------------------------------------------------------- ASOCJACJA
  belongs_to :user

  has_many :contexts, :dependent => :destroy
  has_many :tags, :through => :contexts

  #-----------------------------------------------------------------------------------------------------
  attr_accessible :file_name, :tag_names
  attr_accessor :upload, :tag_names, :context_tagids, :tags_del
  
  #----------------------------------------------------------------------------------- SORTOWANIE
  scope :by_date_desc, :order => "photos.created_at DESC"
  scope :by_date_asc, :order => "photos.created_at ASC"

  #-------------------------------------------------------------------------------------- WALIDACJA
  validates :file_name, :presence => true,
                                 :uniqueness => { :case_sensitive =>false }
  validates :user_id, :presence => true
 
  #--------------------------------------------------------------------------------------- CALLBACKS
  after_save :assign_tags
  after_destroy :destroy_unused_tags
  after_commit :destroy_unused_tags

    private####################################################

    #--------------------------------------------------------------------------------------------------
    def assign_tags
      if @tag_names
        Tag.transaction do
          self.tags = @tag_names.split(/,/).map do |name|
            Tag.find_or_create_by_name(name)
          end
        end
      end
    end

    #--------------------------------------------------------------------------------------------------
    def destroy_unused_tags
      @context_tagids = Context.find(:all).map(&:tag_id).uniq.join(", ")
      unless @context_tagids.empty?
        @tags_del = Tag.where("id NOT IN (#{@context_tagids})")
        @tags_del.each { |del_tag| del_tag.destroy }
      end
    end
    
end
