require 'database'
require 'machine'
Database.test_connect
list_of_machines = ["WHO DUNNIT","ROLLING THUNDER","NO FEAR","ARKANOID","HYPERBALL","RAMPAGE","ROAD SHOW","STAR TREK","DONKEY KONG JR","MR DO","MS PACMAN","SARGE","DOCTOR WHO","HOME RUN","QIX","ROOT BEER TAPPER","FROGGER","TEMPEST","SATANS HOLLOW","BOMB JACK","APB","GALAGA","DONKEY KONG","BURGER TIME","SPACE INVADERS","I ROBOT","MANIA CHALLENGE","DR WHO","MAPPY"]
list_of_machines.each do |machine|
  Machine.new(:name => machine).save
end

Database.disconnect
