class DestcurrsController < ApplicationController
  before_filter :authorize
  before_action :set_destcurr, only: [:show, :edit, :update, :destroy, :view_curr_insertion, :view_curr_pdf]

  def index
    @destcurrs = Destcurr.where(["user_id = ?", session[:user_id]]).all
  end

  def edit
    @filecurrsaveds =  Filecurrsaved.where(["user_id = ?", session[:user_id]]).all
  end

  def show
  end

  def new
    @filecurrsaveds =  Filecurrsaved.where(["user_id = ?", session[:user_id]]).all
    @destcurr = Destcurr.new
  end

  def create
    @filecurrsaveds =  Filecurrsaved.all
    @destcurr = Destcurr.new(destcurr_params)
    @destcurr.user_id = session[:user_id]
    respond_to do |format|
      if @destcurr.save
        format.html { redirect_to @destcurr,  notice: t('Application was successfully created.')}
      else
        format.html { render :new }
      end
    end
  end

  def update
    @filecurrsaveds =  Filecurrsaved.all
    respond_to do |format|
      if @destcurr.update_attributes(destcurr_params)
        format.html {redirect_to @destcurr, notice: t('Application was successfully updated.')}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @destcurr.destroy
    respond_to do |format|
      format.html { redirect_to destcurrs_url, notice: t('Application was successfully destroyed.') }
    end
  end
  
  def view_curr_insertion
    send_pdf_data(:pdf_jobinsertion)
  end
  
  def view_curr_pdf
    send_pdf_data(:pdf_cv)
  end
 
  private

  def send_pdf_data(field_name)
    ascii_data = @destcurr.send(field_name)
    if ascii_data
      send_data( Base64.decode64(ascii_data),
          :filename => "#{field_name}",
          :type => "application/pdf",
          :disposition => "inline" )
    else
      flash[:warn] = t('Pdf file not found')
      redirect_to action: "show", id: params[:id]
    end
  end

  def set_destcurr
    @destcurr = Destcurr.find(params[:id])
    @destcurr = @destcurr.user_id == session[:user_id] ? @destcurr : nil
  end
  
  def destcurr_params
    par = params.require(:destcurr).permit(:inserat, :contact_email, :contact_web, :contact_person, 
      :contact_company, :contact_note, :contact_ams, :curr_sent_at, :colloquio_at, :email_motivaz, :note, 
      :risultato, :destcurr_pdf_jobinsertion, :destcurr_pdf_cv)
    
    return par
  end
  
end
