class Destcurr < ActiveRecord::Base

  def destcurr_pdf_jobinsertion=(pdf_jobinsertion_field)
    self.inserat_filename = base_part_of(pdf_jobinsertion_field.original_filename)
    self.pdf_jobinsertion = Base64.encode64(pdf_jobinsertion_field.read)
  end

  def destcurr_pdf_cv=(destcurr_pdf_cv_field)
    self.pdf_cv_filename = base_part_of(destcurr_pdf_cv_field.original_filename)
    self.pdf_cv = Base64.encode64(destcurr_pdf_cv_field.read)
  end

  private 
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '' )
  end

end
