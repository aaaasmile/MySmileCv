class Language < ActiveRecord::Base
  has_many :identity
  has_many :computerskill
  has_many :education
  has_many :workexperience
  has_many :languageskill
  has_many :otherskill
  has_many :miscstuff
end
