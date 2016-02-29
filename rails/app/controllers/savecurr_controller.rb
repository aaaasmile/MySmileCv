class SavecurrController < ApplicationController
  before_filter :authorize
  
  def save_curr
    @filecurrsaved = Filecurrsaved.new
  end
  
  def update_curr
    curr_obj = find_curriculum
    curr_obj.save_onlastyaml
    flash[:notice] = 'Curriculum saved.'
    redirect_to :action => 'list_cmds', :controller => 'Curriculum'
  end
  
  def create
    @filecurrsaved = Filecurrsaved.new(params[:filecurrsaved])
    log_fnametime = Time.now.strftime("%Y_%m_%d_%H_%M_%S")
    base_dir_log = File.expand_path( File.dirname(__FILE__) + '/../../public/curriculum' )
    FileUtils.mkdir_p(base_dir_log)
    simple_fname = "#{log_fnametime}_curri.yaml"
    curriculum_fname = File.join(base_dir_log, simple_fname)
    # save it into yaml file
    curr_obj = find_curriculum
    curr_obj.save_to_yaml(curriculum_fname, @filecurrsaved.curr_title)
    # save info about yaml file into db
    @filecurrsaved.curr_filename = simple_fname
    if @filecurrsaved.save
      flash[:notice] = 'Curriculum was successfully saved.'
      redirect_to :action => 'list_cmds', :controller => 'Curriculum'
    end
  end
  private

  def find_curriculum
    session[:curriculum] ||= Curriculum.new
  end 
  
end
