# In this case, we create the subscription on node 2 with nc spock sub-create.
#

use strict;
use warnings;
use File::Which;
use IPC::Cmd qw(run);
use Try::Tiny;
use JSON;
use lib './t/lib';
use contains;

# Our parameters are:

our $repuser = `whoami`;
our $username = "$ENV{EDGE_USERNAME}";
our $password = "$ENV{EDGE_PASSWORD}";
our $database = "$ENV{EDGE_DB}";
our $inst_version = "$ENV{EDGE_INST_VERSION}";
our $cmd_version = "$ENV{EDGE_COMPONENT}";
our $spock = "$ENV{EDGE_SPOCK}";
our $cluster = "$ENV{EDGE_CLUSTER}";
our $repset = "$ENV{EDGE_REPSET}";
our $n1 = "$ENV{EDGE_N1}";
our $n2 = "$ENV{EDGE_N2}";
our $n3 = "$ENV{EDGE_N3}";


# We can retrieve the home directory for node 1 from nodectl in json form... 
my $json = `$n1/pgedge/nc --json info`;
#print("my json = $json");
my $out = decode_json($json);
my $homedir1 = $out->[0]->{"home"};
print("The home directory of node 1 is {$homedir1}\n");

# We can retrieve the port number for node 1 from nodectl in json form...
my $json2 = `$n1/pgedge/nc --json info $cmd_version`;
#print("my json = $json2");
my $out2 = decode_json($json2);
my $port1 = $out2->[0]->{"port"};
print("The port number on node 1 is {$port1}\n");


# We can retrieve the home directory for node 2 from nodectl in json form... 
my $json3 = `$n2/pgedge/nc --json info`;
print("my json = $json3");
my $out3 = decode_json($json3);
my $homedir2 = $out3->[0]->{"home"};
print("The home directory of node 2 is {$homedir2}\n");

# We can retrieve the port number for node 2 from nodectl in json form...
my $json4 = `$n2/pgedge/nc --json info $cmd_version`;
print("my json = $json4");
my $out4 = decode_json($json4);
my $port2 = $out4->[0]->{"port"};
print("The port number of node 2 is {$port2}\n");


# Create the subscription on node 2#
print("repuser before chomp = $repuser\n");
chomp($repuser);

my $cmd12 = qq($homedir2/nodectl spock sub-create sub_n2n1 'host=127.0.0.1 port=$port1 user=$repuser dbname=$database' $database);
print("cmd12 = $cmd12\n");
my($success12, $error_message12, $full_buf12, $stdout_buf12, $stderr_buf12)= IPC::Cmd::run(command => $cmd12, verbose => 0);
print("stdout_buf12 = @$stdout_buf12\n");

# Then, we connect with psql and confirm that the subscription exists.

my $cmd7 = qq($homedir2/$cmd_version/bin/psql -t -h 127.0.0.1 -p $port2 -d $database -c "SELECT * FROM spock.subscription");
print("cmd7 = $cmd7\n");
my($success7, $error_message7, $full_buf7, $stdout_buf7, $stderr_buf7)= IPC::Cmd::run(command => $cmd7, verbose => 0);

# Then, confirm that the subscription has been created.

print("We just created the subscription on ($n2) and are now verifying it exists.\n");

if(contains(@$stdout_buf7[0], "sub_n2n1"))

{
    exit(0);
}
else
{
    exit(1);
}


