class DestcurrsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @destcurr_pages, @destcurrs = paginate :destcurrs, :per_page => 10
  end

  def show
    @destcurr = Destcurr.find(params[:id])
  end
  
  def show_next
    id_next = params[:id].to_i + 1
    begin
      @destcurr = Destcurr.find(id_next)
      render :action => 'show'
    rescue
      list
      render :action => 'list'
    end
  end
  
  def show_prev
    id_prev = params[:id].to_i - 1
    begin
      @destcurr = Destcurr.find( id_prev )
      render :action => 'show'
    rescue
      list
      render :action => 'list'
    end
  end

  def new
    @filecurrsaveds =  Filecurrsaved.find(:all)
    @destcurr = Destcurr.new
  end

  def create
    @filecurrsaveds =  Filecurrsaved.find(:all)
    @destcurr = Destcurr.new(params[:destcurr])
    if @destcurr.save
      flash[:notice] = 'Destcurr was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @filecurrsaveds =  Filecurrsaved.find(:all)
    @destcurr = Destcurr.find(params[:id])
  end

  def update
    @filecurrsaveds =  Filecurrsaved.find(:all)
    @destcurr = Destcurr.find(params[:id])
    if @destcurr.update_attributes(params[:destcurr])
      flash[:notice] = 'Destcurr was successfully updated.'
      redirect_to :action => 'show', :id => @destcurr
    else
      render :action => 'edit'
    end
  end

  def destroy
    Destcurr.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def view_curr_insertion
    @destcurr = Destcurr.find(params[:id])
    redirect_to("#{@request.relative_url_root}/inserat/#{@destcurr.inserat_filename}")
  end
  
  def view_curr_pdf
    #title_pdf = curriculum.curr_title
    #title_pdf += '.pdf'
    @destcurr = Destcurr.find(params[:id])
    title_pdf = @destcurr.filecurrsaved.curr_title
    title_pdf += '.pdf'
    #redirect_to(title_pdf)
    redirect_to("#{@request.relative_url_root}/pdf/#{title_pdf}")
    #pdf_file_name = "public/pdf/#{title_pdf}"
  end
  
  def next_item
  end
  
end
