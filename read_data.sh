#!/bin/bash

while true;
do
	# graph 1
	tail -n 8640 /data/co2.txt > /tmp/co2.txt.tmp;
	cat /tmp/co2.txt.tmp > /data/co2.txt;
	rm /tmp/co2.txt.tmp;

	mbtget -r4 -a 100 -s $HVAC_IP|perl -ne 'chomp; s/;//; print time() . "\t$_"'>> /data/co2.txt;
	mbtget -r4 -a 94 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t$_"'>> /data/co2.txt; 
	mbtget -r4 -a 95 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t $_\n"'>> /data/co2.txt;
	gnuplot /co2.gp;
	mv /data/co2.png.tmp /data/co2.png

	# graph 2
	tail -n 8640 /data/temp.txt > /tmp/temp.txt.tmp;
	cat /tmp/temp.txt.tmp > /data/temp.txt;
	rm /tmp/temp.txt.tmp;
	perl -e 'print time()' >> /data/temp.txt;
	OUTSIDE_AIR=$(mbtget -r4 -a 71 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$OUTSIDE_AIR" >> /data/temp.txt;
#	mbtget -r4 -a 71 -s $HVAC_IP|perl -ne 'chomp; s/;//; print time() . "\t" . (unpack(q[s>], pack('cc', 0xff & ($_ >> 8), 0xff & $_)) / 10)'>> /data/temp.txt;
	SUPPLY_AIR=$(mbtget -r4 -a 72 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$SUPPLY_AIR" >> /data/temp.txt
#	mbtget -r4 -a 72 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t" . (unpack(q[s>], pack('cc', 0xff & ($_ >> 8), 0xff & $_)) / 10)'>> /data/temp.txt; 
	ROOM_TEMP=$(mbtget -r4 -a 74 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$ROOM_TEMP" >> /data/temp.txt
#	mbtget -r4 -a 74 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t" . (unpack(q[s>], pack('cc', 0xff & ($_ >> 8), 0xff & $_)) / 10)'>> /data/temp.txt;
	mbtget -r4 -a 75 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t" . (unpack(q[s>], pack('cc', 0xff & ($_ >> 8), 0xff & $_)) / 10)'>> /data/temp.txt; 
	mbtget -r4 -a 76 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t" . (unpack(q[s>], pack('cc', 0xff & ($_ >> 8), 0xff & $_)) / 10) . "\n"'>> /data/temp.txt;
	gnuplot /temp.gp;
	mv /data/temp.png.tmp /data/temp.png

	# graph 3
	tail -n 8640 /data/heat_cooling.txt > /tmp/heat_cooling.txt.tmp;
	cat /tmp/heat_cooling.txt.tmp > /data/heat_cooling.txt;
	rm /tmp/heat_cooling.txt.tmp;

	mbtget -r4 -a 32 -s $HVAC_IP|perl -ne 'chomp; s/;//; print time() . "\t$_"'>> /data/heat_cooling.txt;
	echo -ne "\t$SUPPLY_AIR" >> /data/heat_cooling.txt;
	echo -ne "\t$ROOM_TEMP" >> /data/heat_cooling.txt;
	mbtget -r4 -a 35 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t$_"'>> /data/heat_cooling.txt;
	mbtget -r4 -a 39 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "\t$_\n"'>> /data/heat_cooling.txt;
	gnuplot /heat_cooling.gp;
	mv /data/heat_cooling.png.tmp /data/heat_cooling.png
	
	# save all to db
	# save all to db
#	/save_in_db.pl $ROOM_TEMP,
#				`co2`,
#				`supply_air_volume`,
#				`exhaust_air_volume`,
#				`outside_air`,
#				`outside_air_temp`,
#				`supply_air_temp`,
#				`return_air_temp`,
#				`cooling`,
#				`heat_exchanger`,
#				`heating`
	
	
sleep 10; done  