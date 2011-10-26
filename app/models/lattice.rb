# == Schema Information
# Schema version: 20110401153720
#
# Table name: lattices
#
#  id                          :integer(4)      not null, primary key
#  concept_extent      :text
#  concept_intent      :text
#  created_at           :datetime
#  updated_at          :datetime
#

class Lattice < ActiveRecord::Base
  #-------------------------------------------------------------------------------------- ASOCJACJA
  has_many :edges, :foreign_key => "concept_id", :dependent => :destroy

  #---------------------------------------------------------------------------------------------------
  def self.localise_edges
    @lattice = self.find(:all)

    # @concepts [n][0] = concept_extent | (X, ...)
    # @concepts [n][1] = concept_intent | (..., Y)
    @concepts = Array.new(@lattice.count())
    @concepts.each_index { |i| @concepts[i] = Array.new(2) }

    @tmp_ext = Array.new
    @tmp_int = Array.new
    @tmp_ext = @lattice.map(&:concept_extent)
    @tmp_int = @lattice.map(&:concept_intent)
    @tmp_ext.map! { |item| item.split(",").map(&:to_i) }
    @tmp_int.map! { |item| item.split(",").map(&:to_i) }

    @tmp_ext.each_index do |i|
      @concepts[i][0] = @tmp_ext[i]
      @concepts[i][1] = @tmp_int[i]
    end

    # m..........................................................................................................
    @tag_ids = Tag.find(:all).map(&:id)
    # m = m/Y
    @m_step = Array.new

    @count = Array.new
    # X przeciecie {m'} => X1
    @inters = Array.new
    # {m'}
    @m_prim = Array.new
    # Y1
    @inters_prim = Array.new
    @temp = Array.new
    @temp_edges = Array.new
    @counter = 0
    @tmp_cpt = []; @tmp_edg = []

    # szukanie krawedzi...................................................................................
    @concepts.each_index do |i|
      @idx = i; @count = []; @temp_edges = []
      @m_step = @tag_ids - @concepts[i][1]
      @m_step.each_index do |j|
        @m_prim = Context.find_all_by_tag_id(@m_step[j]).map(&:photo_id)
        @inters = @concepts[@idx][0] & @m_prim
        (@inters.empty?) ? @inters = [0] : @inters
        @temp = self.find_by_concept_extent(@inters.join(",")).concept_intent
        @inters_prim = @temp.split(",").map(&:to_i)
        @count << @inters_prim
      end
      @count.sort!.each_index do |c|
        if @count[c+1] == @count[c]
          @counter += 1
        else
          @counter = 0
        end
        if @counter+1 == (@count[c].count - @concepts[@idx][1].count).abs
          @temp_edges << @count[c]
          @counter = 0
        end
      end
      @temp_edges.each_index do |k|
        @tmp_cpt << @concepts[@idx][0]
        @tmp_edg << @temp_edges[k]
      end
    end

    # zapis db.................................................................................................
    @cpt_edg = Array.new
    @tmp_cpt.each_index do |i|
      @cpt_edg[i] = self.find_all_by_concept_extent(@tmp_cpt[i].join(",")).map(&:id)
    end

    @egd_ext = Array.new
    @edg_int = Array.new
    @tmp_edg.each_index do |i|
      @edg_int[i] = @tmp_edg[i].join(",")
      @egd_ext[i] = (self.find_all_by_concept_intent(@tmp_edg[i].join(",")).map(&:concept_extent)).join(",")
    end

    Edge.transaction do
      @cpt_edg.each_index do |i|
        Edge.find_or_create_by_edge_extent_and_edge_intent_and_concept_id(@egd_ext[i], @edg_int[i], @cpt_edg[i][0])
      end
    end

  end


  #----------------------------------------------------------------------------------------------------
  def self.find_concepts(tags)
    if tags
      @tmp = []; @result = []
      @temp = tags.split(" ")
      @temp.each { |tag| @result << Tag.where("name = ?", tag).map(&:id) }
      @to_find = @result.sort.join(",")

      if @to_find.empty?
        @result = ["false"]
      else
        if (self.find_by_concept_intent(@to_find)).nil?
          # wyszukiwanie najmniejszego pojęcia z tagiem/ami w intent
          # "%" - 0 lub wiecej nieznanych znakow \\  "_" - 1 lnieznany znak
          @temp = self.where('concept_intent LIKE ?', "%#{@to_find}%")
          @temp.each { |tag| @tmp << tag.concept_intent }
          @tmp.sort! { |a, b| a.length <=> b.length }
          if @tmp.empty?
            @result = ["false"]
          else
            @result = self.find_by_concept_intent(@tmp.first).concept_extent
          end
        else
          @result = self.find_by_concept_intent(@to_find).concept_extent
        end
      end
    end

  end
    
end