class PhotosController < ApplicationController
  #----------------------------------------------------------------------------------------------------
  before_filter :authenticate, :only => [:create, :update, :destroy]
  before_filter :verify_file, :only => :create
  before_filter :verify_tag, :only => :update
  before_filter :authorized_user, :only => :destroy

  #----------------------------------------------------------------------------------------------------
  def create
    content_type = params[:photo][:upload].content_type.split('/')
    new_file_name =  "#{ current_user.id }-#{ Time.now.utc.to_f }.#{ content_type[1] }"
    @@test
    @photo = current_user.photos.create(:file_name => new_file_name)
    if @photo.save
      File.open(imgs_location(new_file_name), "wb") { |f| f.write(params[:photo][:upload].read) }
      flash[:success] = "Zdj\u0119cie zosta\u0142o dodane"
      redirect_to (@photo.user)
    else
      flash[:error] = "B\u0142\u0105d ! Spr\u00F3buj ponownie\n"
      redirect_to (@photo.user)
    end
  end

  #----------------------------------------------------------------------------------------------------
  def update
    unless params[:photo][:id].nil?
      @photo = Photo.find(params[:photo][:id])
      if @photo.update_attributes(params[:photo])
        flash[:success] = "Zmiany zosta\u0142y wprowadzone"
        redirect_to (@photo.user)
      else
        flash[:error] = "B\u0142\u0105d ! Spr\u00F3buj ponownie"
        redirect_to (@photo.user)
      end
    else
      flash[:error] = "B\u0142\u0105d ! Brak zdj\u0119\u0107"
      redirect_to current_user
    end
  end
  
  #----------------------------------------------------------------------------------------------------
  def destroy
    if imgs_location(@photo.file_name) && File.exists?(imgs_location(@photo.file_name))
      File.delete(imgs_location(@photo.file_name))
    else
        flash[:error] = "B\u0142\u0105d ! Spr\u00F3buj ponownie"
    end
    @photo.destroy
    flash[:success] = "Plik zosta\u0142 usuni\u0119ty"
    redirect_to (@photo.user)
  end

  private ####################################################

    #--------------------------------------------------------------------------------------------------
    def authorized_user
      @photo = Photo.find(params[:id])
      redirect_to root_path unless current_user?(@photo.user) || current_user.admin?
    end

    #--------------------------------------------------------------------------------------------------
    def verify_file
      if params[:photo].nil?
        flash[:error] = "B\u0142\u0105d ! Nie wprowadzono pliku"
        redirect_to current_user
      else
        unless params[:photo][:upload].content_type.match("image")
          flash[:error] = "B\u0142\u0105d ! nieprawid\u0142owy format pliku"
          redirect_to current_user
        end
      end
    end

    #--------------------------------------------------------------------------------------------------
    def verify_tag
      if params[:photo][:tag_names].empty? || params[:photo][:tag_names].length < 3
        flash[:error] = "B\u0142\u0105d ! Wprowadzono niepoprawne dane"
        redirect_to current_user
      else
        tregex = /\A[a-zA-Z\u0105\u0119\u0142\u0107\u0144\u015B\u00F3\u017A\u017C\u00F2\d\-\,]+\z/i
        unless tregex.match(params[:photo][:tag_names])
          flash[:error] = "B\u0142\u0105d ! Wprowadzono niepoprawne dane"
          redirect_to current_user
        end
      end
    end

end