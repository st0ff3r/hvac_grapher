#!/bin/bash

while true;
do
	# graph 1
	tail -n 8640 /data/co2.txt > /tmp/co2.txt.tmp;
	cat /tmp/co2.txt.tmp > /data/co2.txt;
	rm /tmp/co2.txt.tmp;

	perl -e 'print time()' >> /data/co2.txt;

	CO2=$(mbtget -r4 -a 100 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$CO2" >> /data/co2.txt;
	
	SUPPLY_AIR_VOLUME=$(mbtget -r4 -a 94 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$SUPPLY_AIR_VOLUME" >> /data/co2.txt;
	
	EXHAUST_AIR_VOLUME=$(mbtget -r4 -a 95 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$EXHAUST_AIR_VOLUME\n" >> /data/co2.txt;

	gnuplot /co2.gp;
	mv /data/co2.png.tmp /data/co2.png

	# graph 2
	tail -n 8640 /data/temp.txt > /tmp/temp.txt.tmp;
	cat /tmp/temp.txt.tmp > /data/temp.txt;
	rm /tmp/temp.txt.tmp;

	perl -e 'print time()' >> /data/temp.txt;

	OUTSIDE_AIR_TEMP=$(mbtget -r4 -a 71 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$OUTSIDE_AIR_TEMP" >> /data/temp.txt;

	SUPPLY_AIR_TEMP=$(mbtget -r4 -a 72 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$SUPPLY_AIR_TEMP" >> /data/temp.txt

	ROOM_TEMP=$(mbtget -r4 -a 74 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$ROOM_TEMP" >> /data/temp.txt

	RETURN_AIR_TEMP=$(mbtget -r4 -a 75 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$RETURN_AIR_TEMP" >> /data/temp.txt

	EXHAUST_AIR_TEMP=$(mbtget -r4 -a 76 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	echo -ne "\t$EXHAUST_AIR_TEMP\n" >> /data/temp.txt

	gnuplot /temp.gp;
	mv /data/temp.png.tmp /data/temp.png

	# graph 3
	tail -n 8640 /data/heat_cooling.txt > /tmp/heat_cooling.txt.tmp;
	cat /tmp/heat_cooling.txt.tmp > /data/heat_cooling.txt;
	rm /tmp/heat_cooling.txt.tmp;

	perl -e 'print time()' >> /data/heat_cooling.txt;

	COOLING=$(mbtget -r4 -a 32 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$COOLING" >> /data/heat_cooling.txt;

	echo -ne "\t$SUPPLY_AIR_TEMP" >> /data/heat_cooling.txt;
	echo -ne "\t$ROOM_TEMP" >> /data/heat_cooling.txt;

	HEAT_EXCHANGER=$(mbtget -r4 -a 35 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$HEAT_EXCHANGER" >> /data/heat_cooling.txt;

	HEATING=$(mbtget -r4 -a 39 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	echo -ne "\t$HEATING\n" >> /data/heat_cooling.txt;

	gnuplot /heat_cooling.gp;
	mv /data/heat_cooling.png.tmp /data/heat_cooling.png
	
	# save all to db
	/save_in_db.pl \
				"'$ROOM_TEMP'" \
				"'$CO2'" \
				"'$SUPPLY_AIR_VOLUME'" \
				"'$EXHAUST_AIR_VOLUME'" \
				"'$OUTSIDE_AIR_TEMP'" \
				"'$SUPPLY_AIR_TEMP'" \
				"'$RETURN_AIR_TEMP'" \
				"'$EXHAUST_AIR_TEMP'" \
				"'$COOLING'" \
				"'$HEAT_EXCHANGER'" \
				"'$HEATING'"

	# export all data to file
	/export_db.pl > /data/data.csv.tmp
	mv /data/data.csv.tmp /data/data.csv

sleep 10; done  