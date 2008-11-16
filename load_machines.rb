require 'database'
require 'machine'
Database.test_connect
list_of_machines =["Arkanoid","Tempest","Mr. Do","Ms. Pac","APB","Tapper","I, Robot","Bomb Jack","Rampage (1 credit)","Satan's Hollow","Ridge Racer (time trial)","Mappy","Pengo","Sarge","Frogger","Ultra Hockey","Strike Zone Baseball (3 innings)","Gridiron Fight","Mania Challenge (best of 3)","All American Football (1 quarter or 1 half)","High Impact Football (1 half)","Relief Pitcher (may be replaced by Snow Bros)","The Grid (best of 3)","Star Trek","Dr. Who","Big Bang Bar","No Fear","Hyperball","Home Run","Guns and Roses"]
list_of_machines.each do |machine|
  Machine.new(:name => machine).save
end

Database.disconnect
