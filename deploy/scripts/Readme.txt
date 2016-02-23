== Versione 1.0.1
- mettere in target_deploy_info.yaml la directory dove vengono messe tutte le versioni
- Occorre 7zip e nsis installer. Questi path vanno messi in target_deploy_info.yaml
- La versione che si trova in cuperativa_gui.rb, decide i nomi delle directory e dei files zip
- Occorre una pacchetto con ruby
- Lanciare lo script build_the_setup.rb, esso crea il setup.exe in un colpo solo. 


== Versione 0.9.0
- mettere in target_deploy_info.yaml la directory dove si fa il deploy.
      Questa directory deve avere gi� ruby.
- Usa lo script create_appdata_zip.rb e crea lo zip da mettere in deploy\CupStarterConsoleSharp
- Rebuild di CupStarterConsoleSharp
- Build SetupCup in visual studio

== Quello che si fa per pubblicare la versione 0.7.0

== Super concentrato per creare setup.exe

- mettere in target_deploy_info.yaml la directory dove si fa il deploy.
      Questa directory deve avere gi� ruby.
- Lancia prepare_app_totmp.rb per creare app
- Lancia prepare_nsi_win32_noexe.rb per avere il file nsi
- compila il file nsi con compressione LZMA


=== pacchetti per update da server

1) Completare il sofwtare sul client e il server ed aggiornare le versioni
  all'interno dei programmi (client e server)
2) Creare il manuale:
    - lancia create_manual.rb su linux in cuperativa0508/doc/manual
    - svn commit e aggiungi eventuali sezioni
    - su windows xpp compilare il file cuperativa.hhp per creare cuperativa.chm
    - IMPORTANTE: **** copiare MANUALMENTE cuperativa.chm da windows xp a cuperativa0508/res/help/cuperativa.chm ****
      altrimenti l'installer prende il manuale versione vecchia
3) Creare il setup in win32
   - Vedi sezione sotto
4) Creare i pacchetti per aggiornare il client dal server:
    - modificare lo yaml target_deploy_info.yaml per avere dei folder
      che sono simili alla versione che si vuole pubblicare
    - nella directory cuperativa0508/deploy   
      lanciare lo script prepare_update_src_pack.rb per creare i files per l'update
    - nel file del server mod_conn_cmdh.rb bisogna aggiornare i link per l'update.
      Eventualmente fare l'upload via ftp dei files necessari per scaricare la nuova versione
     
=== Setup win32

Dopo avere completato i punti 1 e 2 del paragrafo precedente bisogna creare il file di setup
per l'installazione su windows.
Come? Bisogna usare windows. Bisogna avere una directory dove si ha gi� la distribuzione
ruby smagrita con solo i pacchetti necessari. Per esempio questa directory:
C:\Biblio\ruby\ruby_win32_deployed\newver
che contiene i subfolders:
\ruby

La directory \ruby deve essere creata manualmente copiando da una precedente
Poi si lancia lo script prepare_app_totmp.rb nella directory cuperativa0508/deploy
per creare la directory \app. Se esiste gi� una sottodirectory \app nel target folder,
questa verr� sovrascritta.
Ora, sempre nella directory cuperativa0508/deploy si lancia lo script  
prepare_nsi_win32_noexe.rb per generare il file nsi. 
Andando nella directory <target customnewver> si potr� lanciare
il file cuperativa_gen.nsi che creer� il setup, per esempio cuperativa_<new ver>_setup.exe.


=== Linux

Nessun pacchetto bin � previsto per questa piattaforma. L'utente pu� per� usare i sorgenti.

== Provare l'update
- Preparazione: 
      * generare il file tgz dei sorgenti full e src con prepare_update_src_pack.rb
      * Avere un mismatch di protocollo tra server e client. Questo fa partire il check delle versioni.
      * Avere un mismatch tra versione client e la lista sul server TABLE_SW_UPDATE in mod_conn_cmdh.rb.
        Questo serve per avviare l'update, se la versione del client non � nella lista del server, l'update 
        non parte
  Fare attenzione che nel pacchetto tgz non ci siano yaml con password varie
  - Caricare i files tgz su 'http://kickers.fabbricadigitale.it/cuperativa/update_packages
  - Essere certi che sul server nella tabella TABLE_SW_UPDATE  vi sia il link al nuovo pacchetto 
    per la vecchia versione.
  - Provare su windows una versione vecchia col nuovo server per vedere se parte l'update. Se il programma si
    pianta al riavvio, probabilmente nel pacchetto tgz sono finiti dei yaml che non vanno bene 
    (esempio log_mode.yml)             


======================================================
== OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD==
======================================================

== Quello che si fa per pubblicare la versione 0.6.1

- Completare il sofwtare sul client e il server ed aggiornare le versioni
  all'interno dei programmi (client e server)
- Creare il manuale:
    - lancia create_manual.rb su linux in cuperativa0508/doc/manual
    - svn commit e aggiungi eventuali sezioni
    - su windows xpp compilare il file cuperativa.hhp per creare cuperativa.chm
    - copiare cuperativa.chm da windows xp a cuperativa0508/res/help/cuperativa.chm
- Creare i pacchetti per aggiornare il client dal server:
    - modificare lo yaml target_deploy_info.yaml per avere dei folder
      che sono simili alla versione che si vuole pubblicare
    - nella directory cuperativa0508/deploy   
      lanciare lo script prepare_update_src_pack.rb per creare i files per l'update


== Pubblicare una versione (linux, windows) dalla ver 0.5.4
La preparazione dell'exe o bin avviene in 2 fasi:
1) Lanciare prepare_app_totmp.rb dopo aver cambiato lo yaml
target_deploy_info.yaml

oppure:
dep = DeployLocalVersion.new
dep.create_all_current_packages

2) A questo punto si ha una directory che per default �:
tmp_deploy
Andare nella directory tmp_deploy e lanciare lo script:
ruby make_cup_exe.rb
Cos� verr� creato l'exe sotto windows e il bin sotto linux.
Ora l'exe e la sottodirectory app sono pronti da impacchettare
nell'exe.

3) Creare il file .nis per il setup usando:
ruby prepare_nsi_win32.rb
Oppure:
dep = DeployLocalVersion.new
dep.create_nsi_installer



======================================================
== OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD==
======================================================
== Pubblicare una versione per windows (fino alla versione 0.5.0)

1) Usare lo script che copia tutti i files necessari nella
directory ../../rubyforge\published

2) Prima di lanciare lo script, cambiare la versione da pubblicare
nelle opzioni. La funzione da lanciare �
dep.deploy_version(options)

3) Andare nella directory ../../rubyforge\published/ver.XXXXX/src
e lanciare make_exe.bat per creare l'exe.

4) con l'exe creato, il file chm del manuale, le release notes
usare per creare il setup
