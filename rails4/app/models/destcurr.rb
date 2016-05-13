class Destcurr < ActiveRecord::Base

  def destcurr_pdf_jobinsertion=(pdf_jobinsertion_field)
    self.pdf_jobinsertion = Base64.encode64(pdf_jobinsertion_field.read)
  end
end
