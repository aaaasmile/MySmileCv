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
    flash[:notice] = 'Curriculum empty'
    redirect_to :action =>  'list_cmds'
  end
  
  def create_pdf
    @curriculum = find_curriculum
    title_pdf = @curriculum.curr_title
    title_pdf = 'new' if title_pdf.length == 0
    title_pdf += '.pdf'
    base_dir_log = File.join(Rails.root, "public/pdf")
    @pdf_file_name = File.join(base_dir_log, title_pdf)
    builder = CurrPdfBuilder.new(@curriculum)
    builder.build_pdf(@pdf_file_name)
    flash[:notice] = 'PDF file  was successfully created.'
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
    @curriculum = find_curriculum
    educations = Education.all
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
    @curriculum = find_curriculum
    skills = Computerskill.all
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
    @curriculum = find_curriculum
    languages = Languageskill.all
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
    @curriculum = find_curriculum
    stuff = Miscstuff.all
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
    @curriculum = find_curriculum
    otherskills = Otherskill.all
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
    @curriculum = find_curriculum
    option = Option.find_by_user_id(session[:user_id]) 
    exps = (option && option.use_only_one_language == 1) ?
        Workexperience.where(["klang = ?", option.language_id]).order("date_from desc") :
        Workexperience.order("date_from desc").all
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
 
end



################## Here because in lib is not refreshed on edit

require 'mypdf/writer' #using an adpted version of pdf writer


class CurrPdfBuilder

  def initialize(curr)
    @curriculum = curr
  end

  def build_pdf(pdf_file_name)
    
    info_identity = @curriculum.cur_identity
    author =  "Igor Sarzi Sartori"
    title = "Sarzi Sartori, Igor - Lebenslauf"
    subject = 'Lebenslauf'
    old_locale = I18n.locale
    if info_identity
      I18n.locale = info_identity.language.isoname.downcase.to_sym
      subject = I18n.t('lebenslauf')
      author = "#{info_identity.firstname} #{info_identity.lastname}"
      title = "#{info_identity.lastname}, #{info_identity.firstname} - #{subject}"
    end

    pdf = PDF::Writer.new(:paper => "A4") 
    pdf.select_font('Helvetica') # Courier, Times-Roman
    x0 = 190
    #y0 = 50
    y0 = pdf.absolute_bottom_margin
    x1 = x0
    y1 = 780
    x2 = 100
    
    col_r_rmargin = 385
    left_part_data = 170
    txt_space = 1.3
    txt_hspace = 2 # space between text and title section
    fnt_size_hfield = 10 # font size of fields
    fnt_size_hsection = 14 # font size of section title
    
    
    pdf.info.author =  author
    pdf.info.title =  title
    pdf.info.subject =  subject
    pdf.info.creator =  "MySmileCV with PDF:Writer"
    #pdf.info.creationdate =  Time.now # Not works?
    
    # first page style
    pdf.line(x0,y0, x1, y1)
    pdf.line_to(x2, y1)
    pdf.stroke  
      
    # style for all other pages >= 1
    pdf.open_object do |lines_water|
      pdf.save_state
      pdf.stroke_color! Color::Black
      pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT
      y1 = pdf.absolute_top_margin
      pdf.line(x0,y0, x1, y1)
      pdf.stroke  
      pdf.restore_state
      pdf.close_object
      pdf.add_object(lines_water, :all_following_pages )
    end
    
    # footer
    pdf.open_object do |footing|
      pdf.save_state
      pdf.stroke_color! Color::RGB::Black
      pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT

      s = 6
      t = "#{I18n.t :lebenslauf_von} <b>#{author}</b> #{I18n.t :created_with}"
      x = pdf.absolute_left_margin
      y = pdf.absolute_bottom_margin
      pdf.add_text(x + 47, 26, t, s)
            
      pdf.restore_state
      pdf.close_object
      pdf.add_object(footing, :all_pages)
    end
    
    # page numeration
    pnx = pdf.absolute_right_margin
    pdf.start_page_numbering(pnx, 26, 6, :right, "<PAGENUM>", 1)
    
    # per disegnare i campi con i dati allineati intorno alla linea verticale
    # uso text con l'allineamento a destra, poi sposto il cursore y dov'era prima
    # e a questo punto mando il testo allineato a sinistra
    up_y = - pdf.font_height(fnt_size_hfield) * txt_space # offset yup
    
    pdf.move_pointer(30)

    if info_identity
      str_tmp = I18n.t :lebenlauf_bold
     
      pdf.text(str_tmp, {:justification => :right, :right => col_r_rmargin, :font_size => 18})
     
      pdf.text("<b>#{I18n.t('Angaben_zur_Person')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)

      # START test
      #pdf.stop_page_numbering(true, :current)
      #pdf.save_as(pdf_file_name)
      #return
      #END Test

      # data identity
      pdf.text(I18n.t(:nachnamen_vorname), :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_hspace)
      pdf.move_pointer(up_y)
      pdf.text("<b>#{cm_isolatin(info_identity.lastname)}, #{cm_isolatin(info_identity.firstname)}</b>", :justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text(I18n.t('Adresse'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield,  :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.address)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text(I18n.t('Telefon'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("<i>#{I18n.t('Mobil')}</i>: #{info_identity.mobile}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('E-mail/Web',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      str_tmp = "<c:alink uri=\"mailto:#{info_identity.email}\">#{info_identity.email}</c:alink>, <i>Web</i>: <c:alink uri=\"http://#{info_identity.web}\">#{info_identity.web}</c:alink>"
      add_each_tostring_inst(str_tmp)
      pdf.text(str_tmp,:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text(I18n.t('Staatsangehörigkeit'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.nationality)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )

      pdf.text(I18n.t('Geburtsdatum'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{datum_format(info_identity.birthdate)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      
      if I18n.locale == :it
        pdf.text('Codice Fiscale',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield,  :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{info_identity.codice_fisc}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      else
        pdf.text('Geschlecht',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield,  :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{cm_isolatin(info_identity.gender)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.text('Familienstand',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{cm_isolatin(info_identity.familystate)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      end

      pdf.move_pointer(4)
    end
    #scope
    if @curriculum.cur_scope
      fnt_size_gb = 12
      txt_space_2lines_gb = 1
      txt_space = 1.3
      up_y_2lines_gb = - pdf.font_height(fnt_size_gb) * txt_space_2lines_gb
      pdf.text("<b>#{I18n.t('Gewünschte_Beschäftigung')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_gb, :spacing => txt_space_2lines_gb)
      y_ag = pdf.y
      if I18n.locale == :de
        pdf.move_pointer(2 * up_y_2lines_gb)
      else
        pdf.move_pointer(up_y_2lines_gb)
      end
      pdf.text("<b>#{cm_isolatin(@curriculum.cur_scope)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_gb,  :spacing => txt_space_2lines_gb )
      y_ag_text = pdf.y
      if y_ag_text > y_ag
        pdf.move_pointer(y_ag_text - y_ag )
      end
    end
    
    # workexperience header
    exp_fnt_height = fnt_size_hsection
    exp_fnt_height -= 3 if I18n.locale == :it
    pdf.text("<b>#{I18n.t('Berufserfahrung')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => exp_fnt_height, :spacing => txt_hspace)
   
    # foto
    if @curriculum.curr_picture
      img_stream = Base64.decode64(@curriculum.curr_picture.foto)
      x_foto = 460
      y_foto = 680
      pdf.add_image(img_stream, x_foto, y_foto, 80)
    end

    #pdf.stop_page_numbering(true, :current)
    #pdf.save_as(pdf_file_name)
    #return

    #workexperience
    we_list = @curriculum.preproc_workexperience_list
    we_list.sort!{|a,b| (a.date_from <=> b.date_from)}
    we_list.reverse!
    inter_leave = 1.5
    txt_space_2lines = 1.5
    up_y_2lines = - pdf.font_height(fnt_size_hfield) * txt_space_2lines # offset yup
    we_list.each do |we_item|
      pdf.text(I18n.t('Datum'),  {:justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space})
      pdf.move_pointer(up_y)
      pdf.text("<b>#{datum_format(we_item.date_from)} - #{datum_format(we_item.date_to)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text(I18n.t('Beruf_oder_Funktion'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.position)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text(I18n.t('Wichtigste Tätigkeiten und Zuständigkeiten'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space_2lines)
      y_ag = pdf.y
      pdf.move_pointer(2 * up_y_2lines)
      # NOTA su bullet: funziona solo se si scrive <C:bullet/>
      #pdf.text("<C:bullet/>#{cm_isolatin(we_item.activities)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space_2lines )
      #we_item.activities.flatten!
      we_item.cumulated_activities.each do |activity_text|
        if we_item.cumulated_activities.size <= 1
          pdf.text("#{cm_isolatin(activity_text)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space_2lines )
        else    
          pdf.text("<C:bullet/>#{cm_isolatin(activity_text).strip}",:justification => :left, :left => left_part_data + 7, :font_size => fnt_size_hfield,  :spacing => txt_space_2lines )
          pdf.move_pointer(2)
        end
      end
      y_ag_text = pdf.y
      # we have the title splitted in two lines, make sure that text goes beyhond the title
      if y_ag_text > y_ag
        pdf.move_pointer(y_ag_text - y_ag )
      end
      pdf.move_pointer(inter_leave)
      
      pdf.text(I18n.t('Name des Arbeitgebers'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.employer)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text(I18n.t('Tätigkeitsbereich_Branche'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.sector)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.move_pointer(4)
    end
    
    # Education
    if @curriculum.cur_education_list.size > 0
      pdf.text("<b>#{I18n.t('Ausbildung')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)
      ed_list = @curriculum.cur_education_list
      ed_list.sort!{|a,b| (a.date_from <=> b.date_from)}
      ed_list.reverse!
      ed_list.each do |ed_item|
        pdf.text(I18n.t('Datum'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("<b>#{datum_format(ed_item.date_from)} - #{datum_format(ed_item.date_to)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(inter_leave)
      
        if ed_item.title.size > 0
          pdf.text(I18n.t('Bezeichnung'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          str_text = "#{ed_item.title}"
          str_text.concat(" (#{ed_item.level})") if ed_item.level.size > 0
          pdf.text(cm_isolatin(str_text),:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        if ed_item.skills.size > 0
          pdf.text(I18n.t('Hauptfächer'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          pdf.text("#{cm_isolatin(ed_item.skills)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        if ed_item.organisation.size > 0
          pdf.text(I18n.t('Ausbildungseinrichtung'),  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          pdf.text("#{cm_isolatin(ed_item.organisation)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        pdf.move_pointer(4)
      end
    end

    # Languages
    if @curriculum.cur_lang_skills.size > 0
      pdf.text("<b>#{I18n.t('Sprachen')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)    
      ed_list = @curriculum.cur_lang_skills
      ed_list.each do |ed_item|
        pdf.text("#{cm_isolatin(ed_item.name)}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{cm_isolatin(ed_item.level)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(inter_leave)
     
        pdf.move_pointer(3)
      end
    end
    
    #computer skills
    if @curriculum.get_cur_computer_skills.size > 0
      pdf.text("<b>#{I18n.t('IKT-Kenntnisse')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)    
      ed_list = @curriculum.get_cur_computer_skills
      ed_list.each do |ed_item|
        pdf.text("#{cm_isolatin(ed_item.name)}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{cm_isolatin(ed_item.experience)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(inter_leave)
     
        pdf.move_pointer(3)
      end
    end
    
    if @curriculum.cur_other_skills.size > 0 || @curriculum.cur_miscstuff_list.size > 0
      pdf.text("<b>#{I18n.t('Zusätzliche_Angaben')}</b>", :justification => :right, :right => col_r_rmargin, :font_size => 12, :spacing => txt_hspace)    
    end

    if @curriculum.cur_other_skills.size > 0
      #other skills - hobbies
      ed_list = @curriculum.cur_other_skills
      pdf.text("#{I18n.t('Hobbies')}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      strtext = ""
      count = 0
      ed_list.each do |ed_item|
        next if ed_item.sktype != 'Hobby'
        prefix = ", "
        prefix = "" if count == 0
        strtext.concat("#{prefix}#{cm_isolatin(ed_item.skill)}")
        count += 1
      end
      pdf.text(strtext,:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(3)
    end
    
    #miscstuff
    if @curriculum.cur_miscstuff_list.size > 0
      ed_list = @curriculum.cur_miscstuff_list.dup
      str_drivinglicense = nil
      # patente
      ed_list.each do |x| 
        if x.mstype == 'drivinglicense'
          str_drivinglicense = "#{cm_isolatin(x.misc)}"
          ed_list.delete(x)
        end 
      end
      if str_drivinglicense
        pdf.text("#{I18n.t('Führerschein')}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text(str_drivinglicense,:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(3)
      end 
      # misc
      txt_space_misc = 1
      up_y_misc = - pdf.font_height(fnt_size_hfield) * txt_space_misc
      pdf.text("#{I18n.t('Verschiedene_Erfahrungen')}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y_misc)
      ed_list.each do |ed_item|
        #next if ed_item.mstype != 'misc'
        str_txt = pdef_replace_link(ed_item.misc)
        str_tmp = "#{cm_isolatin(str_txt)}"
        add_each_tostring_inst(str_tmp)  
        pdf.text(str_tmp,:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space_misc )
        pdf.move_pointer(3)
      end
    end
    
    #pdf.start_columns
    #pdf.start_new_page
    #pdf.move_pointer(-100)
    #pdf.add_text_wrap(10,10,150,"#{cm_isolatin(info_identity.lastname)},#{cm_isolatin(info_identity.firstname)}")
    #info_identity.address.each_byte{|c| p "%x" % c } 
    #pdf.stop_columns
    
    #x = pdf.absolute_right_margin + pdf.font_height(5)
    #y = pdf.absolute_bottom_margin
    #memo = %Q(Copyright 2005 Ryan Davis with Austin Ziegler. PDF version by Austin Ziegler.)
    #pdf.add_text(x, y, memo, 5, 90)
  
    pdf.stop_page_numbering(true, :current)
    
    pdf.save_as(pdf_file_name)
    
    I18n.locale = old_locale 
  end

  def datum_format(datum)
    return datum.strftime("%d.%m.%Y")
  end

   ##
  # Check if text contains a tink tag, something like link:.... 
  # then replace it with link pdf uri
  def pdef_replace_link(txt)
    # NOTE: it works with only link
    link_url = nil
    str_after = ''
    str_before = ''
    aa = txt.split('link:')
    if aa.size == 2
      aa[1].lstrip!
      bb = aa[1].index(/[\)\, ]/)
      link_url = aa[1][0..bb - 1]
      str_after = aa[1][bb..-1]
      str_before = aa[0]
    end

    if link_url
      str_link = "<c:alink uri=\"#{link_url}\">#{link_url.gsub("http://", "")}</c:alink>"
      str_res = str_before + str_link + str_after
    else
      return txt
    end
  end
  
  ##
  # Convert utf8 string to iso-8859-1. pdfwriter want iso8859-1 strings, or utf16
  def cm_isolatin(text_utf8)
    text_utf8 #iso latin conversion is done into the pdf lib
  end

  # in ruby >= 1.9 the String.each method is not valid anymore (replaced by each_line)
  def add_each_tostring_inst(str)
    #def str.each
    #  each_line
    #end
  end

end
