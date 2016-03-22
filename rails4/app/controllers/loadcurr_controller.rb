class LoadcurrController < ApplicationController
  before_filter :authorize
  
  def reload_curr
    id = session[:curriculum]["file_curr_id"]
    @file_loaded = Filecurrsaved.find(id)
    build_curriculum
    flash[:notice] = 'Curriculum reloaded.'
  end
  
  def delete_title
    item = Filecurrsaved.find(params[:filecurrsaved][:id])
    if(item)
      item.destroy
      if session[:curriculum] && item.id.to_s == session[:curriculum]["file_curr_id"]
        session[:curriculum] = Curriculum.new.get_info_for_session
      end
    end
    redirect_to :action => 'list_cmds', :controller => 'Curriculum'
  end
  
  def load_title
    @file_loaded= Filecurrsaved.find(params[:file_loaded][:id])
    build_curriculum
  end

  private

  def build_curriculum
    curr_model = Curriculum.new
    if @file_loaded && curr_model.load_from_yaml(@file_loaded.content)
      curr_model.set_title(@file_loaded.curr_title, @file_loaded.id)
      flash[:notice] = 'Curriculum was successfully loaded.'
    else
      flash[:error_toast] = 'Unable to load curriculum.'
    end
    session[:curriculum] = curr_model.get_info_for_session
    redirect_to :action => :list_cmds, :controller => :curriculum
  end
  
end
