class IdentpicturesController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  def list
    @identpicture_pages, @identpictures = paginate :identpictures, :per_page => 10
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

  def create
    @identpicture = Identpicture.new(params[:identpicture])
    if @identpicture.save
      flash[:notice] = 'Identpicture was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @identpicture = Identpicture.find(params[:id])
  end

  def update
    @identpicture = Identpicture.find(params[:id])
    if @identpicture.update_attributes(params[:identpicture])
      flash[:notice] = 'Identpicture was successfully updated.'
      redirect_to :action => 'show', :id => @identpicture
    else
      render :action => 'edit'
    end
  end

  def destroy
    Identpicture.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
