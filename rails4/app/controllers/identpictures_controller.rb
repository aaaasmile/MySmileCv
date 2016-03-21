class IdentpicturesController < ApplicationController
  before_filter :authorize
  before_action :set_identpicture, only: [:show, :edit, :update, :destroy]
  
  def index
    @identpictures = Identpicture.all
  end
  
  def show
    @identpicture = Identpicture.find(params[:id])
  end
  
  def picture
    @identpicture = Identpicture.find(params[:id])
    #@identpicture.content_type
    #@identpicture.foto_filename
    #p @identpicture.foto
    ascii_data = @identpicture.foto
    send_data( Base64.decode64(ascii_data),
          :filename => @identpicture.foto_filename,
          :type => @identpicture.content_type,
          :disposition => "inline" )

  end

  def new
    @identpicture = Identpicture.new
  end

  def edit
  end

  def create
    p @identpicture = Identpicture.new(identpicture_params)
    respond_to do |format|
      if @identpicture.save
        format.html { redirect_to @identpicture,  notice: 'Picture was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @identpicture.update_attributes(identpicture_params)
        format.html {redirect_to @identpicture, notice: 'Picture was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @identpicture.destroy
    respond_to do |format|
      format.html { redirect_to identpictures_url, notice: 'Picture was successfully destroyed.' }
    end
  end
  
  private
  def set_identpicture
    @identpicture = Identpicture.find(params[:id])
  end
  
  def identpicture_params
    params.require(:identpicture).permit(:identpicture_picture)
  end
  
end
