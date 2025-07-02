#!/usr/bin/perl -w

use strict;
use DBI;

my $mysql_database = $ENV{MYSQL_DATABASE} || die "no database supplied";
my $mysql_user = $ENV{MYSQL_USER} || die "no database username supplied";
my $mysql_password = $ENV{MYSQL_PASSWORD} || die "no database password supplied";

my $dbi = 'DBI:mysql:database=' . $mysql_database . ';host=hvac-db;port=3306';
my $d;

my $dbh = DBI->connect($dbi, $mysql_user, $mysql_password, { mysql_auto_reconnect => 1, mysql_enable_utf8 => 1 }) || die $!;

my $sth = $dbh->prepare(qq[SELECT
							`room_temp`,
							`co2`,
							`supply_air_volume`,
							`exhaust_air_volume`,
							`outside_air_temp`,
							`supply_air_temp`,
							`return_air_temp`,
							`exhaust_air_temp`,
							`cooling`,
							`inverter_signal_output`,
							`heat_exchanger`,
							`heating`,
							FROM_UNIXTIME(`unix_time`) as `t`
						FROM samples ORDER BY `unix_time` ASC]);
$sth->execute || warn $!;

print  "date,room_temp,co2,supply_air_volume,exhaust_air_volume,outside_air_temp,supply_air_temp,return_air_temp,exhaust_air_temp,cooling,inverter_signal_output,heat_exchanger,heating\n";
while ($d = $sth->fetchrow_hashref) {
	print $d->{t} . ",";
	print $d->{room_temp} . ",";
	print $d->{co2} . ",";
	print $d->{supply_air_volume} . ",";
	print $d->{exhaust_air_volume} . ",";
	print $d->{outside_air_temp} . ",";
	print $d->{supply_air_temp} . ",";
	print $d->{return_air_temp} . ",";
	print $d->{exhaust_air_temp} . ",";
	print $d->{cooling} . ",";
	print $d->{inverter_signal_output} . ",";
	print $d->{heat_exchanger} . ",";
	print $d->{heating} . "\n";
}

__END__
