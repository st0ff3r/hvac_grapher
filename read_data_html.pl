#!/usr/bin/perl
use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request;
use JSON;

# Configuration
my $hvac_ip = $ENV{HVAC_IP};
my $base_url = 'http://' . $hvac_ip . '/jsongen.html?fn=read&pin=%s&lng=0&us=2&oa=NgDyDQAA&ioa=BiLNeBoDAAE%%3D';
my $cookie_value_base = 'hmiLng=%%22English%%22; hmiPin=%%22%s%%22';

my $username = 'ADMIN';
my $password = 'SBTAdmin!';
my $pin = '2000';

my $target_json_key = 'CiMqGhoDAAE=';  # inverter_signal_output_c1

# Create user agent
my $ua = LWP::UserAgent->new;
my $url = sprintf($base_url, $pin);
my $formatted_cookie_value = sprintf($cookie_value_base, $pin);

my $req = HTTP::Request->new(GET => $url);
$req->authorization_basic($username, $password);

$req->header('Cookie' => $formatted_cookie_value);

my $res = $ua->request($req);

if ($res->is_success) {
	my $decoded = decode_json($res->decoded_content);
	my $value_items = chomp $decoded->{values}->{NgDyDQAA}->{valueItems};

	if (exists $value_items->{$target_json_key}) {
		print $value_items->{$target_json_key};
	} else {
		warn "Value for inverter_signal_output_c1 not found.\n";
	}
} else {
	warn "Request failed: " . $res->status_line . "\n";
}
