class Destcurr < ActiveRecord::Base
  belongs_to(:filecurrsaved, {:foreign_key => 'kcurr_saved'})
end
