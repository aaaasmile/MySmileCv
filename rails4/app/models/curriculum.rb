# model for curriculum
# Per creare questo modello ho usato il modello Cart dal libro rails2nd ed

class Curriculum
  attr_reader :cur_identity, :cur_computer_skills, :cur_education_list,
      :cur_lang_skills, :cur_miscstuff_list, :cur_other_skills, :cur_workexperience_list,
      :curr_title, :curr_picture, :cur_scope
  attr_accessor :cur_we_only1empl
  
  def initialize
    reset_info
  end
  
  def reset_info
    @cur_identity = nil
    @cur_computer_skills = []
    @cur_education_list = []
    @cur_lang_skills = []
    @cur_miscstuff_list = []
    @cur_other_skills = []
    @cur_workexperience_list = []
    @curr_title = ''
    @curr_file_name = ''
    @curr_picture = nil
    @cur_scope = nil
    @cur_we_only1empl = true
  end
  
  def is_empty?
    if @cur_identity || @curr_picture || @cur_scope ||
       @cur_computer_skills.size > 0 ||
       @cur_education_list.size > 0 ||
       @cur_lang_skills.size > 0 ||
       @cur_miscstuff_list.size > 0 ||
       @cur_other_skills.size > 0 ||
       @cur_workexperience_list.size > 0 
       return false
    else
       return true
    end
  end
  
  def set_title(title)
    @curr_title = title
  end
  
  def save_onlastyaml
    save_to_yaml(@curr_file_name, @curr_title)
  end
  
  def reload
    curr_fname = @curr_file_name
    curr_title = @curr_title
    load_from_yaml(curr_fname)
    @curr_file_name = curr_fname
    @curr_title = curr_title
  end
  
  ##
  # Load curriculum from yaml file
  def load_from_yaml(curr_all_info)
    reset_info
    begin
      @curr_all_info = {}
      @curr_all_info = YAML::load(curr_all_info)  #YAML::load_file(yamlfilename) if File.exist?(yamlfilename)
      
      process_my_curr_all_info
      
      return !is_empty?
    rescue => detail
	  str = "Error load_from_yaml \n"
	  str += detail.backtrace.join("\n")
	  puts str
      reset_info
      return false
    end 
  end

  def process_my_curr_all_info
    id = @curr_all_info[:identity]
    @cur_identity = Identity.find(id) if id
      
    id = @curr_all_info[:picture]
    @curr_picture = Identpicture.find(id) if id
      
    @cur_scope = @curr_all_info[:scope]
    @cur_we_only1empl = true
    #p @curr_all_info
    #@curr_all_info[:cur_we_only1empl]
    @cur_we_only1empl = @curr_all_info[:cur_we_only1empl] if @curr_all_info[:cur_we_only1empl] != nil
    #p "LOAD yaml @cur_we_only1empl => #{@cur_we_only1empl}"
      
      
    # now fill all array elements
    fill_arr_withmodel(@curr_all_info[:computer_skills], :add_computer_skill, Computerskill)
    fill_arr_withmodel(@curr_all_info[:education_list], :add_education, Education )
    fill_arr_withmodel(@curr_all_info[:lang_skills], :add_lang_skill, Languageskill)
    fill_arr_withmodel(@curr_all_info[:miscstuff_list], :add_miscstuff, Miscstuff)
    fill_arr_withmodel(@curr_all_info[:other_skills], :add_otherskill, Otherskill )
    fill_arr_withmodel(@curr_all_info[:workexperience_list], :add_workexperience, Workexperience)

    #@curr_file_name = yamlfilename #TODO curr_file_name shold be the current Filecurrsaved
  end
  
  ##
  # Fill an array using arr_ids input of model model_name
  # model_name: model name, e.g Computeskill
  # arr_ids: array of ids, e.g. [1,2]
  # add_fn_target: method used to add each single item, e.g add_otherskill
  def fill_arr_withmodel(arr_ids, add_fn_target, model_name)
    #p 'fill_arr_withmodel'
    #p arr_ids
    if arr_ids
      tmp = model_name.find(arr_ids)
      if tmp
        tmp.each do |item|
          send add_fn_target, item
        end
      end
    end
  end
  
  ##
  # Save the current curriculum into yaml file
  def save_to_yaml(curriculum_fname, title)
    set_title(title)
    @curr_file_name = curriculum_fname
    
    get_info_for_session

    File.open( curriculum_fname, 'w' ) do |out|
      YAML.dump( @curr_all_info, out )
    end
  end
  
  ##
  # Used to preprocess work experience list. We can put the same employer in one item.
  def preproc_workexperience_list
    res = []
    #@cur_we_only1empl = true # force to true...
    unless @cur_we_only1empl
      cur_workexperience_list.each do |item|
        item.activities = [item.activities]
        res << item
      end
      return res
    end 
    #return cur_workexperience_list
    
    employer = {}
    cur_workexperience_list.each do |item|
      det = employer[item.employer]
      det = [] unless det
      det << item
      employer[item.employer] = det 
    end
    employer.each do |k,v|
      if v.size == 1
        v[0].activities = [v[0].activities]
        v[0].activities.flatten!
        res << v[0]
      else
        # we have more that one activity pro employer
        # first get date, min and max
        min_date_item = v.min{|a,b| a.from <=> b.from }
        max_date_item = v.max{|a,b| a.to <=> b.to }
        pos = []
        aa = v.sort{|a,b| (b.from <=> a.from)}
        aa.each do |ele|
          #p ele.from.strftime("%d.%m.%Y")
          pos << ele.position.split(',')
        end
        position = arr_word_list(pos)
        
        activities = []
        aa.each do |ele|
          #p ele.activities
          #p ele.from
          activities << ele.activities
        end
        
        sect_arr = []
        aa.each do |ele|
          sect_arr << ele.sector.split(',')
        end
        sector = arr_word_list(sect_arr)
        
        wenew = Workexperience.new
        wenew.from = min_date_item.from
        wenew.to = max_date_item.to
        wenew.position = position
        wenew.activities = activities.flatten
        wenew.sector = sector
        wenew.employer = v[0].employer
        res << wenew 
      end
    end
    #res.each{|e| p e.from}
    return res
  end
  
  ##
  # From an array of token, provides a flatten comma separated list with unique tokens
  def arr_word_list(pos)
    pos.flatten!
    pos.each{|e| e.strip!}
    str_res = pos.uniq.join(', ')
    return str_res
  end
  
  ### SCOPE
  def set_scope(txt)
    @cur_scope = txt
  end
  
  ### PICTURE
  def set_picture(picture)
    @curr_picture = picture
  end
  
  def destroy_picture
    @curr_picture = nil
  end
  
  ### WORKEXPERIENCE
  def add_workexperience(item)
    @cur_workexperience_list << item
  end
  
  def destroy_workexperience(id)
    id_num = id.to_i
    @cur_workexperience_list.delete_if{|x| x.id == id_num}
  end
  
  ### OTHERSKILL
  def add_otherskill(item)
    @cur_other_skills << item
  end
  
  def destroy_otherskill(id)
    #p "destroy_otherskill....... #{@cur_other_skills.size}, #{id}"
    id_num = id.to_i #NOTE: id is a string, but x.id is a fixnum
                     #      without conversion there is no deletion
    @cur_other_skills.delete_if{|x| x.id == id_num}
    #@cur_other_skills.each do |ele|
      #p id.class
      #p ele.id.class
      #if ele.id == id
        #@cur_other_skills.delete(ele)
        #p 'deleted element'
      #end 
    #end
    #p "destroy_otherskill after delete ....... #{@cur_other_skills.size}, #{id}"
  end
  
  ### MISCSTUFF
  def add_miscstuff(item)
    @cur_miscstuff_list << item
  end
  
  def destroy_miscstuff(id)
    id_num = id.to_i
    @cur_miscstuff_list.delete_if{|x| x.id == id_num}
  end
  
  ### LANGSKILL
  def add_lang_skill(item)
    @cur_lang_skills << item
  end
  
  def destroy_lang_skill(id)
    id_num = id.to_i
    @cur_lang_skills.delete_if{|x| x.id == id_num}
  end
  
  ### IDENTITY
  def set_identity(iden)
    @cur_identity = iden
  end
  
  def destroy_identity
    @cur_identity = nil
  end
  
  ### COMPUTERSKILL
  def add_computer_skill(item)
    @cur_computer_skills << item
  end
  
  def destroy_computer_skill(id)
    id_num = id.to_i
    @cur_computer_skills.delete_if{|x| x.id == id_num}
  end
  
  ### EDUCATION
  def add_education(item)
    @cur_education_list << item
  end
  
  def destroy_education(id)
    id_num = id.to_i
    @cur_education_list.delete_if{|x| x.id == id_num}
  end

  ### serialize stuff
  
  def self.get_curriculum_from_session(session_info)
    new_instance = Curriculum.new
    new_instance.set_curr_info(session_info)
    new_instance.process_my_curr_all_info
    return new_instance
  end

  def set_curr_info(info_session)
    @curr_all_info = {}
    info_session.each do |k, v|
      @curr_all_info[k.to_sym] = v
    end
  end

  def get_info_for_session
    @curr_all_info = {}
    
    @curr_all_info[:cur_we_only1empl] = @cur_we_only1empl
    @curr_all_info[:identity] = @cur_identity.id if @cur_identity
    
    @curr_all_info[:picture] = @curr_picture.id if @curr_picture
    
    @curr_all_info[:scope] = @cur_scope if @cur_scope
    
    comp_skills = []
    @cur_computer_skills.each{|item| comp_skills << item.id}
    @curr_all_info[:computer_skills] = comp_skills
    
    education_list = []
    @cur_education_list.each{|item| education_list << item.id}
    @curr_all_info[:education_list] = education_list 
    
    lang_skills = []
    @cur_lang_skills.each{|item| lang_skills << item.id}
    @curr_all_info[:lang_skills] = lang_skills
    
    miscstuff_list = []
    @cur_miscstuff_list.each{|item| miscstuff_list << item.id}
    @curr_all_info[:miscstuff_list] = miscstuff_list 
    
    other_skills = []
    @cur_other_skills.each{|item| other_skills << item.id}
    @curr_all_info[:other_skills] = other_skills 
    
    workexperience_list = []
    @cur_workexperience_list.each{|item| workexperience_list << item.id}
    @curr_all_info[:workexperience_list] = workexperience_list 

    return @curr_all_info
  end

end