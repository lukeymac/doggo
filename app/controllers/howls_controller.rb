class HowlsController < ApplicationController
  before_action :set_howl, only: [:show, :edit, :update, :destroy, :love, :unlove]
  before_action :owned_howl, only: [:edit, :update, :destroy]

  def index
    @howls = Howl.of_followed_users(current_user.following).order('created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.json { render json: @howls }
    end
  end

  def browse
    @howls = Howl.all.order('created_at DESC').page params[:page]
    respond_to do |format|
      format.html
      format.json { render json: @howls }
    end
  end

  def new
    @howl = current_user.howls.build
  end

  def create
    @howl = current_user.howls.build(howl_params)

    if @howl.save
      flash[:success] = "You have Howled loud and clear for all to hear!"
      redirect_to '/browse'
    else
      flash.now[:alert] = "Your boofer seems to be broken. Try again!"
      render :new
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @howl }
    end
  end

  def edit
  end

  def update
    if @howl.update(howl_params)
      flash[:success] = "HOOOOOWWWWWLL!!!!!"
      redirect_to(howls_path(@howl))
    else
      flash.now[:alert] = "Your re-boofer isn't boofing. Boof again."
      render :edit
    end
  end

  def destroy
    @howl.destroy
    flash[:alert] = "That boofer has been muzzled for good."
    redirect_to root_path
  end

  def love #liked_by is an 'acts_as_votable' method
    if @howl.liked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def unlove
    if @howl.unliked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  private
    def howl_params
      params.require(:howl).permit(:image, :caption, scents_attributes: [:stench, :howl_id])
    end

    def set_howl
      @howl = Howl.find(params[:id])
    end

    def owned_howl
      unless current_user == @howl.user
        flash[:alert] = "Paws off! That's not your howl!"
        redirect_to root_path
      end
    end

end
