class LoadcurrController < ApplicationController
  before_filter :authorize
  
  def load_curr
    @files_available = Filecurrsaved.where(["user_id = ?", session[:user_id]]).all
  end

  def reload_curr
    id = session[:curriculum]["file_curr_id"]
    @file_loaded = Filecurrsaved.find_by(id: id)
    if @file_loaded 
      build_curriculum
      flash[:notice] = t'Curriculum reloaded.'
    else
      redirect_to :action => :list_cmds, :controller => :curriculum
    end
  end
  
  def load_last
    @file_loaded = Filecurrsaved.where(["user_id = ?", session[:user_id]]).last
    if @file_loaded 
      build_curriculum
    else
      flash[:notice] = t'No saved curriculum found.'
      redirect_to :action => :list_cmds, :controller => :curriculum
    end
  end
  
  def delete_curr
    file_id = session[:curriculum]["file_curr_id"]
    item = Filecurrsaved.find_by(id: file_id)
    if(item && session[:user_id] == item.user_id)
      item.destroy
      new_curr = Curriculum.new
      session[:curriculum] = new_curr.get_info_for_session
      flash[:notice] = t'Curriculum detroyed.'
    end
    redirect_to :action => :list_cmds, :controller => :curriculum
  end
  
  def load_title
    @file_loaded= Filecurrsaved.find(params[:file_loaded][:id])
    @file_loaded = @file_loaded.user_id == session[:user_id] ? @file_loaded : nil
    build_curriculum
  end

  private

  def build_curriculum
    curr_model = Curriculum.new
    if @file_loaded && curr_model.load_from_yaml(@file_loaded.content)
      curr_model.set_title(@file_loaded.curr_title, @file_loaded.id)
      flash[:notice] = t'Curriculum was successfully loaded.'
    else
      flash[:error_toast] = t'Unable to load curriculum.'
    end
    session[:curriculum] = curr_model.get_info_for_session
    redirect_to action: :list_cmds, controller: :curriculum
  end
  
end
