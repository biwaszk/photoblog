module ApplicationHelper
  #----------------------------------------------------------------------------------------------------
  def title
    main_title = "Photoblog"
    if @page_title.nil?
      main_title
    else
      "#{@page_title} @ #{main_title}"
    end
  end

  #----------------------------------------------------------------------------------------------------
  def logo
    image_tag("logo.png", :alt => "PHOTOBLOG", :class => "logo")
  end
  
  #----------------------------------------------------------------------------------------------------
  def imgs_location(img_name)
    Rails.root.join('public', 'users_photos', img_name)
  end
  
end