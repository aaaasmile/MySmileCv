# MySmileCv

Sul mio server dell'invido ho fatto il deployment del Curriculum che usa rails e ruby 2.4
Passenger dopo l'upgrade di ubuntu a 20.04 non riesco più a farlo andare.
Dovrei aggiornare ruby i suoi gems e va a finire che non funziona più niente.
Allora uso nginx come proxy e faccio partire manualmente l'applicazione.
Come? Con il semplice comando nella shell sul server:

  @ubu-vido:~/app/MySmileCv/rails4$ bundle exec rails s -p 3001