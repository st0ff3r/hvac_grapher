#!/usr/bin/perl -w

use strict;
use DBI;

my $dbi = 'DBI:mysql:database=hvac;host=db;port=3306';

my $dbh = DBI->connect($dbi, 'hvac', 'aibie7Kufae8TioC', { mysql_auto_reconnect => 1, mysql_enable_utf8 => 1 }) || die $!;

my $quoted_room_temp =			$ARGV[0] || die "need to supply all parameters";
my $quoted_co2 =				$ARGV[1] || die "need to supply all parameters";
my $quoted_supply_air_volume =	$ARGV[2] || die "need to supply all parameters";
my $quoted_exhaust_air_volume =	$ARGV[3] || die "need to supply all parameters";
my $quoted_outside_air =		$ARGV[4] || die "need to supply all parameters";
my $quoted_outside_air_temp =	$ARGV[5] || die "need to supply all parameters";
my $quoted_supply_air_temp =	$ARGV[6] || die "need to supply all parameters";
my $quoted_return_air_temp =	$ARGV[7] || die "need to supply all parameters";
my $quoted_cooling =			$ARGV[8] || die "need to supply all parameters";
my $quoted_heat_exchanger =		$ARGV[9] || die "need to supply all parameters";
my $quoted_heating =			$ARGV[10] || die "need to supply all parameters";

$dbh->do(qq[INSERT INTO `samples` (
				`room_temp`,
				`co2`,
				`supply_air_volume`,
				`exhaust_air_volume`,
				`outside_air`,
				`outside_air_temp`,
				`supply_air_temp`,
				`return_air_temp`,
				`cooling`,
				`heat_exchanger`,
				`heating`,
				`unix_time`)
			VALUES (
				$quoted_room_temp,
				$quoted_co2,
				$quoted_supply_air_volume,
				$quoted_exhaust_air_volume,
				$quoted_outside_air,
				$quoted_outside_air_temp,
				$quoted_supply_air_temp,
				$quoted_return_air_temp,
				$quoted_cooling,
				$quoted_heat_exchanger,
				$quoted_heating,
				UNIX_TIMESTAMP())]
) or die $!;
