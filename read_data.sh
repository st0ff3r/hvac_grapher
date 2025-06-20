#!/bin/bash

while true;
do
	CO2=$(mbtget -r4 -a 100 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')	
	SUPPLY_AIR_VOLUME=$(mbtget -r4 -a 94 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	EXHAUST_AIR_VOLUME=$(mbtget -r4 -a 95 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	OUTSIDE_AIR_TEMP=$(mbtget -r4 -a 71 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	SUPPLY_AIR_TEMP=$(mbtget -r4 -a 72 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	ROOM_TEMP=$(mbtget -r4 -a 74 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	RETURN_AIR_TEMP=$(mbtget -r4 -a 75 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	EXHAUST_AIR_TEMP=$(mbtget -r4 -a 76 -s $HVAC_IP|perl -ne 'chomp; s/;//; print unpack(q[s>], pack(q[cc], 0xff & ($_ >> 8), 0xff & $_)) / 10')
	COOLING=$(mbtget -r4 -a 32 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	HEAT_EXCHANGER=$(mbtget -r4 -a 35 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')
	HEATING=$(mbtget -r4 -a 39 -s $HVAC_IP|perl -ne 'chomp; s/;//; print "$_"')

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