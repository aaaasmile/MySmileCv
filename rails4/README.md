* Ruby version
Sviluppato con 2.4.11


## Start server
Usare il comando:
bundle exec rails s -p 3001
Sotto windows il server puma non va, allora:
setruby224
bundle exec rails s webrick -p 3001

## Passaggio dalla versione 1.2.3
Da rails 1.2.3 a rails 4.2.6 è cambiato molto e non so quanto valga la pena riusare i files.
Ora si usa bundle, ruby 2.1.7 o superiore.
Quello che prima era in public (javascripts e css) vanno a finire in app/assets.
Ma per librerie come jquery e boostrap, si includono usando il Gemfile di bundle e poi
includendole in application.js e application.scss (rinominato apposta per usarlo con boostrap).
Nel file di layout poi bisogna includere solo il file application.js/.scss con gli include che sono
messi in commento, questo mi ha creato confusione, ma in javascript non esiste il comando 'require jquery'
Il controller e le view sono cambiati. I dati che vengono salvati nella session sono sempre serializzazioni
dell'oggetto e non l'istanza dell'oggetto, quindi ho dovuto ricreare l'oggetto Curriculum ad ogni richiesta.
Il delete di un record, o risorsa come viene chiamato ora, viene fatto attraverso un tag dell'html <a>,
per questo occorre jqueryu. Le routes vengono annesse automaticamente con il comando resources: in routes.rb.
Per l'update di una risorsa, occorre avere qualcosa come params.require(:identity).permit(<lista dei campi ammessi>,
prima questo codice era nel modello, ora è nel controllo.
Le icone in boostrap (glyphicon) vengono incluse di default e se boostrap va, vanno anche le icone
senza fare nulla.

Nella picture, per far funzionare il modello bisogna usare nel form il multipart=true in questo modo
<%= form_for(@identpicture, html:{multipart: true})
Nel validates_format_of del modello, la regex /^image/ diventa /\Aimage/


### Snippets non chiari

        <%= link_to(identity, class: 'btn btn-default', aria:{label: 'Show'} ) do %>
            <span class="glyphicon glyphicon-align-left" aria-hidden="true"></span>
        <% end %>

Genera:
        <a class="btn btn-default" aria-label="Show" href="/identities/2">
        <span class="glyphicon glyphicon-align-left" aria-hidden="true"></span>
        </a>

### Comandi da ricordare
Creare una migrazione

        rails g migration AddDateRefToWorkexperience
Per eseguirla:

        rake db:migrate
Per cancellarla:
        rake db:rollback

## Nuovo utente
rails console
myuser = User.new
myuser.salt = '<salt>'
myuser.name = '<nome>'
myuser.hashed_password = User.encrypted_password('<password>', myuser.salt)
myuser.save

## Server developement 
usare il questo comando per avere l'accesso da altri pc:
bundle exec rails s webrick  -b 172.28.2.15 -p 3001

## PDF
La libreria pdf-writer (gem 'pdf-writer', '1.1.8') non va con utf8. Quindi l'ho copiata in rails4/lib e rinominata mypdf.
Tutti i files li ho convertiti in ascii con notepad++ e ho messo l'intestazione 

        # -*- coding: ASCII-8BIT -*-
In cima ad ogni files in modo che le stringhe dichiarate nei vari files fossero in formato binario.
Poi nella funzione preprocess_text ho messo la conversione in ISO-8859-1, altrimenti gli accenti non
funzionano. 
Altra particolarità per quanto riguarda gli spazi, nel file writer.rb si trova:

        char = char[0] unless @fonts[font].c[char]
Ma da ruby 1.9.3 char[0] non produce nulla e quindi occorre chiamare la funzione ord:

        char = char.respond_to?(:ord) ? char.ord : char[0]

