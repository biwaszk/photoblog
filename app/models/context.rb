# == Schema Information
# Schema version: 20110401153720
#
# Table name: contexts
#
#  id                  :integer(4)      not null, primary key
#  photo_id        :integer(4)
#  tag_id           :integer(4)
#  created_at    :datetime
#  updated_at   :datetime
#

class Context < ActiveRecord::Base
  #-------------------------------------------------------------------------------------- ASOCJACJA
  belongs_to :photo
  belongs_to :tag

  #----------------------------------------------------------------------------------------------------
  validates :photo_id, :presence => true
  validates :tag_id, :presence => true

  #----------------------------------------------------------------------------------------------------
  after_commit :construct_lattice, :if => :check_size?
  after_destroy :construct_lattice, :if => :check_size?

  private####################################################

    #---------------------------------------------------------------------------------------------------
    def check_size?
      (Context.limit(6).count > 5) ? true : false
    end

    #---------------------------------------------------------------------------------------------------
    def construct_lattice
      Lattice.delete_all
      Edge.delete_all
      # tablica id wszystkich tagow (m)....................................................................
      @c_int = Array.new
      @c_int[0] = Tag.find(:all).map(&:id)
      # suma wszystkich tagow
      @c_int_sum = @c_int[0].count

      # tablica id zdjęć które mają wszyskie tagi (m')................................................
      @c_ext = Array.new
      # tablica id wszystkich zdjęć powiązanych z tagami
      @pt_id = Context.find(:all).map(&:photo_id)
      # szukanie wartości dla @c_ext, zlicznie powtarzajacych sie id zdjec, jezeli id wystapi
      # tyle razy co suma tagow -1, oznacza to że dane photo ma wszystkie tagi (atrybuty z m)
      @temp = Array.new
      @counter = 0
      @pt_id.each_index do |i|
        if @pt_id[i+1] == @pt_id[i]
          @counter += 1
          @temp << @pt_id[i] if @counter == @c_int_sum - 1
        else
          @counter = 0
        end
        @c_ext[0] = @temp
      end
      (@c_ext[0].empty?) ? @c_ext[0] = [0] : @c_ext

      # tablica id zdjec (g) \ unikalne wartosci..........................................................
      @c_g = @pt_id.uniq

      # generowanie pojec kontekstu (intent)...........................................................
      @inters = Array.new
      @c_g.each do |g|
        # tablica id tagów każdego zdjęcia (g')
        @photo_tags = Context.find_all_by_photo_id(g).map(&:tag_id)
        @c_int.each_index do |i|
          @inters[i] = @c_int[i] & @photo_tags
        end
        @inters.each_index do |i|
          @c_int << @inters[i]
          @c_int.uniq!
        end
      end
      # generowanie pojec kontekstu (extent)..........................................................
      @tmp = Array.new
      @c_int.each_index do |idx|
        @idx = idx; @tmp = []
        @c_g.each do |ph_id|
          @ph_tags = Context.find_all_by_photo_id(ph_id).map(&:tag_id).sort
          @tmp << ph_id if (@ph_tags & @c_int[@idx]) == @c_int[@idx]
        end
        (@tmp.empty?) ? @c_ext[@idx] = [0] : @c_ext[@idx] = @tmp
      end

      # zamiana na tablice stringow........................................................................
      @c_ext.map! { |el| el.join(",")}
      @c_int.map! { |el| el.join(",")}

      # zapis zbioru pojec......................................................................................
      Lattice.transaction do
        @c_ext.each_index do |i|
          Lattice.find_or_create_by_concept_extent_and_concept_intent(@c_ext[i], @c_int[i])
        end
      end

      # wyszukiwanie krawedzi..............................................................................
      Lattice.localise_edges
      
    end

end