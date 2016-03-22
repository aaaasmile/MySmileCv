class LoadcurrController < ApplicationController
  before_filter :authorize
  
  def load_curr
  end
  
  def delete_curr
  end
  
  ##
  # reload current curriculum
  def reload_curr
    curr_model = find_curriculum
    curr_model.reload
    flash[:notice] = 'Curriculum reloaded.'
    redirect_to :action => 'list_cmds', :controller => 'Curriculum'
  end
  
  def delete_title
    Filecurrsaved.find(params[:filecurrsaved][:id]).destroy
    curr_model = find_curriculum
    flash[:notice] = 'Curriculum destroyed.'
    redirect_to :action => 'list_cmds', :controller => 'Curriculum'
  end
  
  def load_title
    @file_loaded= Filecurrsaved.find(params[:file_loaded][:id])
    curr_model = Curriculum.new
    if curr_model.load_from_yaml(@file_loaded.content)
      curr_model.set_title(@file_loaded.curr_title)
      flash[:notice] = 'Curriculum was successfully loaded.'
    else
      flash[:error_toast] = 'Unable to load curriculum.'
    end
    session[:curriculum] = curr_model.get_info_for_session
    redirect_to :action => :list_cmds, :controller => :curriculum

  end
  
  private

  def find_curriculum
    session[:curriculum] ||= Curriculum.new
  end 
end
