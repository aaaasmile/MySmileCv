# -*- coding: ISO-8859-1 -*-

$:.unshift File.dirname(__FILE__)
$:.unshift File.dirname(__FILE__) + "/.."
$:.unshift File.dirname(__FILE__) + "/../../.."

require 'rubygems'
if RUBY_VERSION == "1.8.7"
  require 'pdf/writer'
else
  require 'mypdf/writer'
  require 'mypdf/writer/graphics'
end

#require 'imageinfo.rb'

# Apre un immagine in formato jpg e vede se viene riconosciuta

#print "Image Formats: #{PDF::Writer::Graphics::ImageInfo.formats.inspect}\n"

#    open('igor_portrait.jpg', "rb") do |fh|
#      image = PDF::Writer::Graphics::ImageInfo.new(fh.read)
#			print <<-EOF
#Format  : #{image.format}
#Width   : #{image.width.inspect}
#Height  : #{image.height.inspect}
#Bits    : #{image.bits.inspect}
#Channels: #{image.channels.inspect}
#			EOF
#		end

# Stampa il pdf per vedere se i margini sono corretti

    pdf_file_name = "Luzzo.pdf"
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
    
    
    #pdf.add_text_wrap("Ruby is fun!")
    # per disegnare i campi con i dati allineati intorno alla linea verticale
    # uso text con l'allineamento a destra, poi sposto il cursore y dov'era prima
    # e a questo punto mando il testo allineato a sinistra
    up_y = - pdf.font_height(fnt_size_hfield) * txt_space # offset yup
    #col_r_rmargin = pdf.page_width - x1
    
    #pdf.start_page_numbering(300, 500, 20, nil, nil, 1)    
    
    pdf.move_pointer(30)


    str_tmp = '<b>Lebenslauf</b>'
     
    pdf.text('<b>Lebenslauf</b>', :justification => :right, :right => col_r_rmargin, :font_size => 18)
    pdf.text('<b>Angaben zur Person</b>', :justification => :right, :right => col_r_rmargin, :font_size => fnt_size_hsection, :spacing => txt_hspace)
      
    # START test
    pdf.stop_page_numbering(true, :current)
    pdf.save_as(pdf_file_name)
    
    puts "File created #{pdf_file_name}"
    cmd = "\"C:/Program Files (x86)/Adobe/Reader 11.0/Reader/AcroRd32.exe\""
    cmd += " "
    cmd += File.join(File.expand_path(File.dirname(__FILE__)), pdf_file_name)
    IO.popen(cmd, "r") do |io|
      io.each_line do |line|
        print line 
      end
    end
    print "Open it with adobe..."