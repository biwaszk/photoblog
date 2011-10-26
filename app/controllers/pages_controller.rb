class PagesController < ApplicationController

  #-----------------------------------------------------------------------------------------------------
  def home
    @page_title = "Home"
    @last_photo = Photo.order.last
  end

  #-----------------------------------------------------------------------------------------------------
  def photos
    @page_title = "Galeria"
    if params[:sort] == "desc" || params[:sort].nil?
      @photos_all = Photo.by_date_desc.paginate(:per_page => 6, :page => params[:page])
    elsif params[:sort] == "asc"
      @photos_all = Photo.by_date_asc.paginate(:per_page => 6, :page => params[:page])
    else
      @show_photos = Tag.find(params[:sort]).photos
      @photos_all = @show_photos.by_date_desc.paginate(:per_page => 6, :page => params[:page])
    end
    @tags_all = Tag.by_name.find(:all)
  end

end
