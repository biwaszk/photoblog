class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy

  #-----------------------------------------------------------------------------------------------------
  def new
    @page_title = "Rejestracja"
    @user = User.new
  end

  #-----------------------------------------------------------------------------------------------------
  def index
    @page_title = "U\u017Cytkownicy"
    @users = User.paginate(:per_page => 20, :page => params[:page])
  end

  #-----------------------------------------------------------------------------------------------------
  def show
    @user = User.find(params[:id])
    @user_found = @find_user
    @page_title = "#{@user.name} | Foto"
    @photo = Photo.new if signed_in?
    @photos = @user.photos.by_date_desc.paginate(:per_page => 6, :page => params[:page])
  end

  #-----------------------------------------------------------------------------------------------------
  def search
    unless params[:name]==""
      @find_user = User.find_by_name(params[:name])
      unless @find_user.nil?
          redirect_to user_path(@find_user)
      else
        flash[:success] = "Szukany uzytkownik nie istnieje"
        redirect_to users_path
      end
    else
      flash[:error] = "B\u0142\u0105d !  Nie wprowadzono Aliasu"
      redirect_to users_path
    end
  end

  #-----------------------------------------------------------------------------------------------------
  def edit
    @page_title = "#{@user.name} | Dane"
  end

  #-----------------------------------------------------------------------------------------------------
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = " #{@user.name} witamy na Photoblogu "
      redirect_to @user
    else
      [:password, :password_confirmation].each do |p|
        params[:user][p].clear
      end
      @page_title = "Rejestracja"
      render 'new'
    end
  end

  #-----------------------------------------------------------------------------------------------------
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Zapisano wprowadzone zmiany"
      redirect_to @user
    else
      [:password, :password_confirmation].each do |p|
        params[:user][p].clear
      end
      render 'edit'
    end
  end

  #-----------------------------------------------------------------------------------------------------
  def destroy
    @user_photos = Photo.find_all_by_user_id(params[:id])
    @user_photos.length.times do |i|
      File.delete(imgs_location(@user_photos[i]['file_name'])) if imgs_location(@user_photos[i]['file_name']) && File.exists?(imgs_location(@user_photos[i]['file_name']))
    end
    User.find(params[:id]).destroy
    flash[:success] = "U\u017Cytkownik zosta\u0142 usuni\u0119ty"
    redirect_to users_path
  end

  private####################################################
    
    #--------------------------------------------------------------------------- UWIERZYTELNIANIE
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    #-------------------------------------------------------------------
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end