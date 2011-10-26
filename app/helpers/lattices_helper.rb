module LatticesHelper

  #----------------------------------------------------------------------------------------------------
  def identify_tag_names(tag_ids)
    @temp = []; @result = []
    @temp = tag_ids.split(",").map(&:to_i)
    @temp.each { |id| @result << Tag.find(id).name }
    @result.sort.join(" ")
  end

  #----------------------------------------------------------------------------------------------------
  def lower_neighbours(cpt)
    @concept = Lattice.find_by_concept_extent(cpt)
    @edges = @concept.edges
    @e_temp = Array.new
    @edges.each_index do |i|
      @e_temp[i] = @edges[i].edge_intent.split(",").map(&:to_i)
    end
    @e_temp
  end

    #----------------------------------------------------------------------------------------------------
  def upper_neighbours(cpt)
    @edgs = Edge.find_all_by_edge_extent(cpt)
    @c_tmp = Array.new()
    @c_nghs = Array.new()
    @edgs.each { |item| @c_tmp << item.concept }
    @c_tmp.each_index do |i|
      @c_nghs[i] = @c_tmp[i].concept_intent.split(",").map(&:to_i)
    end
    @c_nghs
  end
  
  #----------------------------------------------------------------------------------------------------
  def  identify_tags (tag_ids)
    @names = Array.new(tag_ids.length)
    @names.each_index do |i|
      @names[i] = Array.new(2)
    end
    tag_ids.each_index do |i|
      @idx = i
      tag_ids[i].each_index do |j|
        @names[@idx][j] = Tag.find(tag_ids[@idx][j]).name
      end
    end
    @names    
  end

end
