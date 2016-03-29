class SavecurrController < ApplicationController
  before_filter :authorize
  
  def save_curr
    @filecurrsaved = Filecurrsaved.new
  end
  
  def update_curr
    curr_obj = find_curriculum
    file_curr = Filecurrsaved.find_by(id: curr_obj.file_curr_id)
    file_curr.content = YAML.dump(curr_obj.get_info_for_session)
    if file_curr.save
      flash[:notice] = 'Curriculum saved.'
    else
      flash[:notice] = 'Unable to save.'
    end
    redirect_to :action => :list_cmds, :controller => :curriculum
  end
  
  def create
    @filecurrsaved = Filecurrsaved.new(params[:filecurrsaved])
    curr_obj = find_curriculum
    @filecurrsaved.content = YAML.dump(curr_obj.get_info_for_session)

    if @filecurrsaved.save
      flash[:notice] = 'Curriculum was successfully saved.'
    else
      flash[:notice] = 'Curriculum save failed.'
    end
    redirect_to :action => :list_cmds, :controller => :curriculum
  end

  private

  def find_curriculum
    session[:curriculum] ||= {}
    Curriculum.get_curriculum_from_session(session[:curriculum])
  end 
  
end
