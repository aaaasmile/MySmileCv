class Miscstuff < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    # nota che il metodo type fa parte del metodo dell'oggetto base di ruby
    # Per vedere la colonna che si chiama 'type' si usa [:type].
    # Purtroppo non mi funzionano i  metodi nella view, meglio usare un altro nome
    "#{misc},#{mstype}"
  end
  
end
