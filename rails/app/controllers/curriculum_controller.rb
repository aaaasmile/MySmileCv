require 'pdf/writer'
require 'iconv'

class CurriculumController < ApplicationController
  before_filter :authorize
  
  def index
    @curriculum = find_curriculum
    render :action => 'list_cmds'
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
    base_dir_log = File.expand_path( File.dirname(__FILE__) + '/../../public/pdf' )
    FileUtils.mkdir_p(base_dir_log)
    @pdf_file_name = File.join(base_dir_log, title_pdf)
    build_pdf
    #flash[:notice] = 'PDF file  was successfully created.'
    #redirect_to :action =>  'list_cmds'
    redirect_to("#{@request.relative_url_root}/pdf/#{title_pdf}")
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
    redirect_to :action =>  'list_cmds'
  end
  
  ### methods to add items to the current curriculum #######
  
  def curr_add_picture
    @curriculum = find_curriculum
    picture = Identpicture.find(params[:id])
    @curriculum.set_picture(picture)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_set_identity
    @curriculum = find_curriculum
    ident = Identity.find(params[:id])
    @curriculum.set_identity(ident)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_education
    @curriculum = find_curriculum
    edu = Education.find(params[:id])
    @curriculum.add_education(edu)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_education
    @curriculum = find_curriculum
    skill = Education.find(:all)
    skill.each{|x| @curriculum.add_education(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_computer_skill
    @curriculum = find_curriculum
    skill = Computerskill.find(params[:id])
    @curriculum.add_computer_skill(skill)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_computerskill
    @curriculum = find_curriculum
    skill = Computerskill.find(:all)
    skill.each{|x| @curriculum.add_computer_skill(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_lang_skill
    @curriculum = find_curriculum
    skill = Languageskill.find(params[:id])
    @curriculum.add_lang_skill(skill)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_languages
    @curriculum = find_curriculum
    skill = Languageskill.find(:all)
    skill.each{|x| @curriculum.add_lang_skill(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_miscstuff
    @curriculum = find_curriculum
    skill = Miscstuff.find(params[:id])
    @curriculum.add_miscstuff(skill)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_miscstuff
    @curriculum = find_curriculum
    skill = Miscstuff.find(:all)
    skill.each{|x| @curriculum.add_miscstuff(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_otherskill
    @curriculum = find_curriculum
    skill = Otherskill.find(params[:id])
    @curriculum.add_otherskill(skill)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_otherskill
    @curriculum = find_curriculum
    skill = Otherskill.find(:all)
    skill.each{|x| @curriculum.add_otherskill(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_workexperience
    @curriculum = find_curriculum
    skill = Workexperience.find(params[:id])
    @curriculum.add_workexperience(skill)
    redirect_to :action =>  'list_cmds'
  end
  
  def curr_add_all_workexperience
    @curriculum = find_curriculum
    exps = Workexperience.find(:all)
    exps.each{|x| @curriculum.add_workexperience(x)}
    redirect_to :action =>  'list_cmds'
  end
  
  ######### remove stuff #######################################
  
  def remove_scope
    @curriculum = find_curriculum
    @curriculum.set_scope(nil)
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_picture
    @curriculum = find_curriculum
    @curriculum.destroy_picture
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_identity
    @curriculum = find_curriculum
    @curriculum.destroy_identity
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_workexperince
    @curriculum = find_curriculum
    @curriculum.destroy_workexperience(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_education
    @curriculum = find_curriculum
    @curriculum.destroy_education(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_languageskill
    @curriculum = find_curriculum
    @curriculum.destroy_lang_skill(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_computerskill
    @curriculum = find_curriculum
    @curriculum.destroy_computer_skill(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_otherskill
    @curriculum = find_curriculum
    @curriculum.destroy_otherskill(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  def remove_miscstuff
    @curriculum = find_curriculum
    @curriculum.destroy_miscstuff(params[:id])
    redirect_to :action =>  'list_cmds'
  end
  
  
  ################################ PRIVATE SESSION #########
  private

  def find_curriculum
    session[:curriculum] ||= Curriculum.new
  end 
  
  def build_pdf
    pdf = PDF::Writer.new(:paper => "A4") 
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
    
    
    pdf.info.author =  "Igor Sarzi Sartori"
    pdf.info.title =  "Sarzi Sartori, Igor - Lebenslauf"
    pdf.info.subject =  "Lebenslauf"
    pdf.info.creator =  "Curr_rails with PDF:Writer"
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
      #pdf.line_to(x2, y1)
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
      t = "Lebenslauf von <b>Igor Sarzi Sartori</b>"
      x = pdf.absolute_left_margin
      y = pdf.absolute_bottom_margin
      pdf.add_text(x + 47, 26, t, s)
      #pdf.pointer = 26
      #pdf.text( t, :justification => :right, :right => col_r_rmargin, :font_size => s)
            
      pdf.restore_state
      pdf.close_object
      pdf.add_object(footing, :all_pages)
    end

    
    # page numeration
    pnx = pdf.absolute_right_margin
    pdf.start_page_numbering(pnx, 26, 6, :right, "<PAGENUM>", 1)
    
    info_identity = @curriculum.cur_identity
    
    #pdf.add_text_wrap("Ruby is fun!")
    # per disegnare i campi con i dati allineati intorno alla linea verticale
    # uso text con l'allineamento a destra, poi sposto il cursore y dov'era prima
    # e a questo punto mando il testo allineato a sinistra
    up_y = - pdf.font_height(fnt_size_hfield) * txt_space # offset yup
    #col_r_rmargin = pdf.page_width - x1
    
    #pdf.start_page_numbering(300, 500, 20, nil, nil, 1)
    
    
    pdf.move_pointer(30)
    if info_identity
      pdf.text('<b>Lebenslauf</b>', :justification => :right, :right => col_r_rmargin, :font_size => 18)
      pdf.text('<b>Angaben zur Person</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)
      # data identity
      pdf.text('Nachnamen/Vorname', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_hspace)
      pdf.move_pointer(up_y)
      pdf.text("<b>#{cm_isolatin(info_identity.lastname)}, #{cm_isolatin(info_identity.firstname)}</b>", :justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Adresse',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield,  :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.address)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Telefon',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("<i>Mobil</i>: #{info_identity.mobile}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      # FAX ??? pretty old stuff
      #pdf.text('Fax',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      #pdf.move_pointer(up_y)
      #pdf.text("#{info_identity.fax}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('E-mail/Web',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("<c:alink uri=\"mailto:#{info_identity.email}\">#{info_identity.email}</c:alink>, <i>Web</i>: <c:alink uri=\"http://#{info_identity.web}\">#{info_identity.web}</c:alink>",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Staatsangehörigkeit',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.nationality)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Geburtsdatum',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{datum_format(info_identity.birthdate)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Geschlecht',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield,  :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.gender)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.text('Familienstand',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(info_identity.familystate)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
    
      pdf.move_pointer(4)
    end
    #scope
    if @curriculum.cur_scope
      fnt_size_gb = 12
      txt_space_2lines_gb = 1
      txt_space = 1.3
      up_y_2lines_gb = - pdf.font_height(fnt_size_gb) * txt_space_2lines_gb
      pdf.text('<b>Gewünschte Beschäftigung</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_gb, :spacing => txt_space_2lines_gb)
      y_ag = pdf.y
      pdf.move_pointer(2 * up_y_2lines_gb)
      pdf.text("<b>#{cm_isolatin(@curriculum.cur_scope)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_gb,  :spacing => txt_space_2lines_gb )
      y_ag_text = pdf.y
      if y_ag_text > y_ag
        pdf.move_pointer(y_ag_text - y_ag )
      end
    end
    
    pdf.text('<b>Berufserfahrung</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)
    
    # foto
    if @curriculum.curr_picture
      img_stream = Base64.decode64(@curriculum.curr_picture.foto)
      x_foto = 440
      y_foto = 670
      pdf.add_image(img_stream, x_foto, y_foto, 100 )
    end
    
    #workexperience
    we_list = @curriculum.preproc_workexperience_list
    #we_list = @curriculum.cur_workexperience_list
    we_list.sort!{|a,b| (a.from <=> b.from)}
    we_list.reverse!
    inter_leave = 1.5
    txt_space_2lines = 1.5
    up_y_2lines = - pdf.font_height(fnt_size_hfield) * txt_space_2lines # offset yup
    we_list.each do |we_item|
      pdf.text('Datum',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("<b>#{datum_format(we_item.from)} - #{datum_format(we_item.to)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text('Beruf oder Funktion',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.position)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text('Wichtigste Tätigkeiten und Zuständigkeiten',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space_2lines)
      y_ag = pdf.y
      pdf.move_pointer(2 * up_y_2lines)
      # NOTA su bullet: funziona solo se si scrive <C:bullet/>
      #pdf.text("<C:bullet/>#{cm_isolatin(we_item.activities)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space_2lines )
      #we_item.activities.flatten!
      we_item.activities.each do |activity_text|
        if we_item.activities.size <= 1
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
      
      pdf.text('Name des Arbeitgebers',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.employer)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.text('Tätigkeitsbereich/Branche',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y)
      pdf.text("#{cm_isolatin(we_item.sector)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
      pdf.move_pointer(inter_leave)
      
      pdf.move_pointer(4)
    end
    
    # Education
    if @curriculum.cur_education_list.size > 0
      pdf.text('<b>Ausbildung</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)
      ed_list = @curriculum.cur_education_list
      ed_list.sort!{|a,b| (a.from <=> b.from)}
      ed_list.reverse!
      ed_list.each do |ed_item|
        pdf.text('Datum',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("<b>#{datum_format(ed_item.from)} - #{datum_format(ed_item.to)}</b>",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(inter_leave)
      
        if ed_item.title.size > 0
          pdf.text('Bezeichnung',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          str_text = "#{ed_item.title}"
          str_text.concat(" (#{ed_item.level})") if ed_item.level.size > 0
          pdf.text(cm_isolatin(str_text),:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        if ed_item.skills.size > 0
          pdf.text('Hauptfächer',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          pdf.text("#{cm_isolatin(ed_item.skills)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        if ed_item.organisation.size > 0
          pdf.text('Ausbildungseinrichtung',  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
          pdf.move_pointer(up_y)
          pdf.text("#{cm_isolatin(ed_item.organisation)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
          pdf.move_pointer(inter_leave)
        end
      
        pdf.move_pointer(4)
      end
    end

    # Languages
    if @curriculum.cur_lang_skills.size > 0
      pdf.text('<b>Sprachen</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)    
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
    if @curriculum.cur_computer_skills.size > 0
      pdf.text('<b>IKT-Kenntnisse</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)    
      ed_list = @curriculum.cur_computer_skills
      ed_list.each do |ed_item|
        pdf.text("#{cm_isolatin(ed_item.name)}",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text("#{cm_isolatin(ed_item.experience)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(inter_leave)
     
        pdf.move_pointer(3)
      end
    end
    
    if @curriculum.cur_other_skills.size > 0
      pdf.text('<b>Zusätzliche Angaben</b>', :justification => :right, :right => col_r_rmargin, :font_size => 12, :spacing => txt_hspace)    
      #other skills - hobbies
      ed_list = @curriculum.cur_other_skills
      pdf.text("Hobbies",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
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
        pdf.text("Führerschein",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
        pdf.move_pointer(up_y)
        pdf.text(str_drivinglicense,:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space )
        pdf.move_pointer(3)
      end 
      # misc
      txt_space_misc = 1
      up_y_misc = - pdf.font_height(fnt_size_hfield) * txt_space_misc
      pdf.text("Verschiedene Erfahrungen",  :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hfield, :spacing => txt_space)
      pdf.move_pointer(up_y_misc)
      ed_list.each do |ed_item|
        #next if ed_item.mstype != 'misc'
        str_txt = pdef_replace_link(ed_item.misc)
        pdf.text("#{cm_isolatin(str_txt)}",:justification => :left, :left => left_part_data, :font_size => fnt_size_hfield,  :spacing => txt_space_misc )
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
    
    pdf.save_as(@pdf_file_name)
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
    return Iconv.new('iso-8859-1', 'utf-8').iconv(text_utf8)
  end
  
end
