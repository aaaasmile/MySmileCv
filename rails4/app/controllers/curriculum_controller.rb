class CurriculumController < ApplicationController
  before_filter :authorize
  
  def index
    @curriculum = find_curriculum
    render :list_cmds
  end
  
  def list_cmds
    @curriculum = find_curriculum
  end
  
  ##### View commands
  
  def clear_curriculum
    session[:curriculum] = nil
    flash[:notice] = t'Curriculum is empty'
    redirect_to :action =>  'list_cmds'
  end
  
  def create_pdf
    @curriculum = find_curriculum
    title_pdf = @curriculum.curr_title
    title_pdf = 'new' if title_pdf.length == 0
    title_pdf += '.pdf'
    base_dir_log = File.join(Rails.root, "public/pdf")
    @pdf_file_name = File.join(base_dir_log, title_pdf)
    builder = PdfBuilderController.new(@curriculum)
    builder.build_pdf(@pdf_file_name)
    #flash[:notice] = t'PDF file  was successfully created.'
    send_file(@pdf_file_name, filename: title_pdf, disposition: 'inline', type: "application/pdf")
  end
  
  def save_extra_options
    @curriculum = find_curriculum
    val = params['curriculum']['cur_we_only1empl']
    @curriculum.cur_we_only1empl =  val
    redirect_to :action =>  'list_cmds'
  end
  
  def create_scope
    @curriculum = find_curriculum
    scope = params['curriculum']['cur_scope']
    @curriculum.set_scope(scope)
    goto_list_of_cmds
  end
  
  ### methods to add items to the current curriculum #######
  def goto_list_of_cmds
    session[:curriculum] = @curriculum.get_info_for_session
    redirect_to :action => :list_cmds
  end

  def curr_add_picture
    @curriculum = find_curriculum
    picture = Identpicture.find(params[:id])
    @curriculum.set_picture(picture)
    goto_list_of_cmds
  end
  
  def curr_set_identity
    @curriculum = find_curriculum
    ident = Identity.find(params[:id])
    @curriculum.set_identity(ident)
    goto_list_of_cmds
  end
  
  def curr_add_education
    @curriculum = find_curriculum
    edu = Education.find(params[:id])
    @curriculum.add_education(edu)
    goto_list_of_cmds
  end
  
  def curr_add_all_education
    @curriculum = find_curriculum_with_option
    educations = Education.where(["klang = ? and user_id = ?", @option.language_id, @userid]).all
    educations.each{|x| @curriculum.add_education(x)}
    goto_list_of_cmds
  end
  
  def curr_add_computer_skill
    @curriculum = find_curriculum
    skill = Computerskill.find(params[:id])
    @curriculum.add_computer_skill(skill)
    goto_list_of_cmds
  end
  
  def curr_add_all_computerskill
    @curriculum = find_curriculum_with_option
    skills = Computerskill.where(["klang = ? and user_id = ?", @option.language_id, @userid]).all
    skills.each{|x| @curriculum.add_computer_skill(x)}
    goto_list_of_cmds
  end
  
  def curr_add_languageskill
    @curriculum = find_curriculum
    skill = Languageskill.find(params[:id])
    @curriculum.add_languageskill(skill)
    goto_list_of_cmds
  end
  
  def curr_add_all_languageskill
    @curriculum = find_curriculum_with_option
    languages = Languageskill.where(["klang = ? and user_id = ?", @option.language_id, @userid]).all
    languages.each{|x| @curriculum.add_languageskill(x)}
    goto_list_of_cmds
  end
  
  def curr_add_miscstuff
    @curriculum = find_curriculum
    skill = Miscstuff.find(params[:id])
    @curriculum.add_miscstuff(skill)
    goto_list_of_cmds
  end
  
  def curr_add_all_miscstuff
    @curriculum = find_curriculum_with_option
    stuff = Miscstuff.where(["klang = ? and user_id = ?", @option.language_id, @userid]).all
    stuff.each{|x| @curriculum.add_miscstuff(x)}
    goto_list_of_cmds
  end
  
  def curr_add_otherskill
    @curriculum = find_curriculum
    skill = Otherskill.find(params[:id])
    @curriculum.add_otherskill(skill)
    goto_list_of_cmds
  end
  
  def curr_add_all_otherskill
    @curriculum = find_curriculum_with_option
    otherskills = Otherskill.where(["klang = ? and user_id = ?", @option.language_id, @userid]).all
    otherskills.each{|x| @curriculum.add_otherskill(x)}
    goto_list_of_cmds
  end
  
  def curr_add_workexperience
    @curriculum = find_curriculum
    skill = Workexperience.find(params[:id])
    @curriculum.add_workexperience(skill)
    goto_list_of_cmds
  end
  
  def curr_add_all_workexperience
    @curriculum = find_curriculum_with_option
    exps = Workexperience.where(["klang = ? and user_id = ?", @option.language_id, @userid]).order("date_from desc")
    exps.each{|x| @curriculum.add_workexperience(x)}
    goto_list_of_cmds
  end
  
  ######### remove stuff #######################################
  
  def remove_scope
    @curriculum = find_curriculum
    @curriculum.set_scope(nil)
    goto_list_of_cmds
  end
  
  def remove_picture
    @curriculum = find_curriculum
    @curriculum.destroy_picture
    goto_list_of_cmds
  end
  
  def remove_identity
    @curriculum = find_curriculum
    @curriculum.destroy_identity
    goto_list_of_cmds
  end
  
  def remove_workexperience
    @curriculum = find_curriculum
    p params
    @curriculum.destroy_workexperience(params[:id])
    goto_list_of_cmds
  end
  
  def remove_education
    @curriculum = find_curriculum
    @curriculum.destroy_education(params[:id])
    goto_list_of_cmds
  end
  
  def remove_languageskill
    @curriculum = find_curriculum
    @curriculum.destroy_lang_skill(params[:id])
    goto_list_of_cmds
  end
  
  def remove_computerskill
    @curriculum = find_curriculum
    @curriculum.destroy_computer_skill(params[:id])
    goto_list_of_cmds
  end
  
  def remove_otherskill
    @curriculum = find_curriculum
    @curriculum.destroy_otherskill(params[:id])
    goto_list_of_cmds
  end
  
  def remove_miscstuff
    @curriculum = find_curriculum
    @curriculum.destroy_miscstuff(params[:id])
    goto_list_of_cmds
  end

  ########################## other

  def edit_curr_scope
    @curriculum = find_curriculum
  end
  
  
  ################################ PRIVATE SESSION #########
  private

  def find_curriculum
    session[:curriculum] ||= {}
    Curriculum.get_curriculum_from_session(session[:curriculum])
  end 

  def find_curriculum_with_option
    @userid = session[:user_id]
    @option = Option.find_by_user_id(@userid) 
    if !@option
      @option = Option.new
      @option.language_id =  Language.where(['isoname = ?', 'IT']).first.id
    end

    find_curriculum
  end
end



