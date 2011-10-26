class LatticesController < ApplicationController

  #----------------------------------------------------------------------------------------------------
  def index
    @page_title = "Lattice - TESTY "
    @concepts = Lattice.paginate(:per_page => 40, :page => params[:page])
  end

  #----------------------------------------------------------------------------------------------------
  def find
    @page_title = "Szukaj"
    
    if params[:page].nil?
      @results = Array.new
      if params[:tagi]=="SZUKAJ" || params[:tagi].match(/^[ +]/)
        @results = ["false"]
      else
        @founded = Lattice.find_concepts(params[:tagi])
        if @founded==["false"] || @founded=="0"
          @results = ["false"]
        else
          $rem_tags = params[:tagi]
          $rem_cpt = @founded
          @temp = @founded.split(",").map(&:to_i)
          @temp.each { |id| @results << Photo.find(id) }
        end
      end
      if @results==["false"]
        flash[:error] = "Brak wynik\u00F3w dla zadanych kryteri\u00F3w wyszukiwania !!!"
        redirect_to foto_path
      else
        $rem_results = @results
      end
    end

    if $rem_results
      current_page = params[:page] || 1
      per_page = 6
      size = $rem_results.length
      @page_results = WillPaginate::Collection.create(current_page, per_page, size) do |pager|
        start = (current_page.to_i-1)*per_page
        pager.replace($rem_results[start, per_page])
      end
    end

end

  #----------------------------------------------------------------------------------------------------
  def auto_compliter
    @auto = Tag.search(params[:search])
    respond_to do |format|
      #format.html {render :layout => false }
      format.js
    end
  end

end
