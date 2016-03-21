class DestcurrsController < ApplicationController
  before_filter :authorize
  before_action :set_destcurr, only: [:show, :edit, :update, :destroy, :view_curr_insertion]

  def index
    @destcurrs = Destcurr.all
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

  def edit
    @filecurrsaveds =  Filecurrsaved.find(:all)
  end

  def create
    @filecurrsaveds =  Filecurrsaved.find(:all)
    @destcurr = Destcurr.new(destcurr_params)
    respond_to do |format|
      if @destcurr.save
        format.html { redirect_to @destcurr,  notice: 'Curricula sent was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    @filecurrsaveds =  Filecurrsaved.find(:all)
    respond_to do |format|
      if @destcurr.update_attributes(destcurr_params)
        format.html {redirect_to @destcurr, notice: 'Curricula sent was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @destcurr.destroy
    respond_to do |format|
      format.html { redirect_to destcurrs_url, notice: 'Curricula sent was successfully destroyed.' }
    end
  end
  
  def view_curr_insertion
    inserat_fname = Rails.root.join('public', 'inserat', @destcurr.inserat_filename)
    if File.exist?(inserat_fname)
      # inserat_fname.relative_path_from(Rails.root).to_s # Pathname class
      redirect_to("inserat/#{@destcurr.inserat_filename}")
    else
      render :show
    end
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

  private
  def set_destcurr
    @destcurr = Destcurr.find(params[:id])
  end
  
  def destcurr_params
    par = params.require(:destcurr).permit(:inserat, :contact_email, :contact_web, :contact_person, 
      :contact_company, :contact_note, :contact_ams, :curr_sent_at, :colloquio_at, :email_motivaz, :note, 
      :risultato, :kcurr_saved, :inserat_filename)
    
    return par
  end
  
end
