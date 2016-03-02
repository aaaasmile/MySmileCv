== change the databse structure
Use migration. For example:
ruby script/generate migration add_file_content

Modify the migration file and apply it with:
rake db:migrate