class Identity < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{firstname}, #{lastname}, #{address}, #{mobile}, #{email}, #{web}, #{birthdate}, #{gender}, #{nationality}, #{other}, #{familystate}"
  end
  
end
