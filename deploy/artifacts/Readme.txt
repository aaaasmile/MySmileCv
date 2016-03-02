== MySmileCv

Software used to generate a pdf CV.
This is a rails application embedded into a c# starter.
The setup does not contains the rails application, that needs to be created from github.

= Application setup
The rails application is always changing, so it is better to use git to be synchronized.
Git should be installed.

After the first run, goto to %localappdata%\invido_it\MySmileCv\<latest_version>\app
and open a  prompt command.
set PATH=C:\Program Files (x86)\Git\bin;%PATH%
git clone -n https://github.com/aaaasmile/MySmileCv
cd MySmileCv
git fetch
git checkout origin/master rails

== No Git?
This is not recommended because changes are not synchronized across multiple installations.
If git is not installed, you can get the zip repository from https://github.com/aaaasmile/MySmileCv and unzip it in 
%localappdata%\invido_it\MySmileCv\<latest_version>\app

= Web
https://github.com/aaaasmile/MySmileCv