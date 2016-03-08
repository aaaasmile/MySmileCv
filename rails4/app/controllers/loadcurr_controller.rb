class LoadcurrController < ApplicationController
  before_filter :authorize
  
  def load_curr
    #@filecurrsaveds = Filecurrsaved.find(:all) # codice messo nella view
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
    @FileCurr= Filecurrsaved.find(params[:filecurrsaved][:id])
    curr_model = find_curriculum
    #p "lo yaml vale:"
    #p title_yaml_fname = "public/curriculum/#{@FileCurr.curr_filename}"
    #base_dir = File.expand_path( File.dirname(__FILE__) + '/../../public/curriculum' )
    #title_yaml_fname = File.join( base_dir, @FileCurr.curr_filename)
	#p @FileCurr.content
    if curr_model.load_from_yaml(@FileCurr.content)
      curr_model.set_title(@FileCurr.curr_title)
      flash[:notice] = 'Curriculum was successfully loaded.'
    else
      flash[:error_toast] = 'Unable to load curriculum.'
    end
    redirect_to :action => 'list_cmds', :controller => 'Curriculum'

  end
  
  private

  def find_curriculum
    session[:curriculum] ||= Curriculum.new
  end 
end
