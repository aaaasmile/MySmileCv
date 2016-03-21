class Identpicture < ActiveRecord::Base
  
  validates_format_of :content_type, 
        :with => /\Aimage/, :message => "-- you can only upload pictures"
   

  def identpicture_picture=(picture_field)
    #p picture_field.class
    self.foto_filename  = base_part_of(picture_field.original_filename)
    self.content_type = picture_field.content_type.chomp
    self.foto         = Base64.encode64(picture_field.read) # we are using a text blob because we have problems with sqlite binary
  end
 
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '' )
  end

  
end
