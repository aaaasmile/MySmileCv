== Db on github
Vorrei che il file development.sqlite3 quando viene cambiato sia aggiornato su github

= setup the remote db
set PATH=C:\Program Files (x86)\Git\bin;%PATH%
git clone -n https://github.com/aaaasmile/MySmileCv
git fetch
git checkout origin/master rails/curr_rails/db/development.sqlite3

In database.yml change to:
database: db/MySmileCv/rails/curr_rails/db/development.sqlite3


== change the databse structure
Use migration. For example:
ruby script/generate migration add_file_content

Modify the migration file and apply it with:
rake db:migrate