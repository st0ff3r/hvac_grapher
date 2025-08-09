#!/usr/bin/perl -w

use strict;
use warnings;
use DBI;

my $mysql_database = $ENV{MYSQL_DATABASE} || die "no database supplied";
my $mysql_user = $ENV{MYSQL_USER} || die "no database username supplied";
my $mysql_password = $ENV{MYSQL_PASSWORD} || die "no database password supplied";

my $dbi = 'DBI:mysql:database=' . $mysql_database . ';host=hvac-db;port=3306';

my $dbh = DBI->connect($dbi, $mysql_user, $mysql_password, { mysql_auto_reconnect => 1, mysql_enable_utf8 => 1 })
  or die "Cannot connect to database: $DBI::errstr";

# Constants
my $rho = 1.2;		   # Air density kg/m3
my $cp = 1.005;		  # Specific heat capacity kJ/kg·K (same as kW·s/kg·K)
my $heat_per_person = 0.3; # Heat output per person in kW (300 W)
my $co2_baseline = 400;  # CO2 baseline ppm without people
my $co2_per_person = 10; # Estimated CO2 increase ppm per person

# Prepare SQL query to get recent 1000 rows with required data
my $sth = $dbh->prepare("
  SELECT unix_time, supply_air_temp, return_air_temp, supply_air_volume, co2 
  FROM samples
  WHERE supply_air_temp IS NOT NULL AND return_air_temp IS NOT NULL AND supply_air_volume IS NOT NULL AND co2 IS NOT NULL
  ORDER BY unix_time DESC LIMIT 1000
");
$sth->execute();

while (my $row = $sth->fetchrow_hashref) {
	my $time_unix = $row->{unix_time};
	my $T_in = $row->{supply_air_temp};
	my $T_out = $row->{return_air_temp};
	my $V = $row->{supply_air_volume}; # m3/h
	my $co2 = $row->{co2};
	
	# Calculate mass flow in kg/s
	my $m_dot = $V * $rho / 3600;
	
	# Calculate heat load Q in kW
	my $Q = $m_dot * $cp * ($T_out - $T_in); # kW
	
	# Estimate number of people from heat load
	my $N_heat = $Q / $heat_per_person;
	
	# Estimate number of people from CO2 (linear approx.)
	my $delta_co2 = $co2 - $co2_baseline;
	my $N_co2 = $delta_co2 / $co2_per_person;
	$N_co2 = 0 if $N_co2 < 0;
	
	# Convert UNIX timestamp to human-readable format
	my ($sec,$min,$hour,$mday,$mon,$year) = localtime($time_unix);
	$year += 1900; $mon += 1;
	my $time_str = sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year,$mon,$mday,$hour,$min,$sec);
	
	printf "%s | T_in=%.2f°C, T_out=%.2f°C, Vol=%.1f m3/h, CO2=%.0f ppm | Heat Q=%.2f kW, N_heat=%.1f, N_CO2=%.1f\n",
	  $time_str, $T_in, $T_out, $V, $co2, $Q, $N_heat, $N_co2;
}

$dbh->disconnect;
