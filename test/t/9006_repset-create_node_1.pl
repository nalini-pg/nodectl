# This is part of a complex test case; after creating a two node cluster on the localhost, 
# the test case executes the commands in the Getting Started Guide at the pgEdge website.
#
# In this case, we'll register node 1 and create the repset on that node.
# After creating the repset, we'll query the spock.replication_set_table to see if the repset exists. 


use strict;
use warnings;
use File::Which;
use IPC::Cmd qw(run);
use Try::Tiny;
use JSON;
use lib './lib';
use contains;

# Our parameters are:

my $cmd99 = qq(whoami);
my ($success99, $error_message99, $full_buf99, $stdout_buf99, $stderr_buf99)= IPC::Cmd::run(command => $cmd99, verbose => 0);
print("stdout_buf99 = @$stdout_buf99\n");

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

# We can retrieve the home directory from nodectl in json form... 

my $json = `$n1/pgedge/nc --json info`;
#print("my json = $json");
my $out = decode_json($json);
my $homedir = $out->[0]->{"home"};
print("The home directory is {$homedir}\n"); 

# We can retrieve the port number from nodectl in json form...
my $json2 = `$n1/pgedge/nc --json info $cmd_version`;
#print("my json = $json2");
my $out2 = decode_json($json2);
my $port = $out2->[0]->{"port"};
# print("The port number is {$port}\n");

# Register node 1 and the repset entry on n1: 
print("repuser before chomp = $repuser\n");
chomp($repuser);
my $cmd2 = qq($homedir/nodectl spock node-create n1 'host=127.0.0.1 port=$port user=$repuser dbname=$database' $database);
print("cmd2 = $cmd2\n");
my ($success2, $error_message2, $full_buf2, $stdout_buf2, $stderr_buf2)= IPC::Cmd::run(command => $cmd2, verbose => 0);

print("stdout_buf2 = @$stdout_buf2\n");

# The next couple of stanzas test to make sure we ERROR out sensibly if a parameter is omitted...
# Test to ensure that a repset name must be provided:

my $cmd30 = qq($homedir/nodectl spock repset-create $database);
print("cmd30 = $cmd30\n");
my ($success30, $error_message30, $full_buf30, $stdout_buf30, $stderr_buf30)= IPC::Cmd::run(command => $cmd30, verbose => 0);
print("stdout_buf30 = @$stdout_buf30\n");
if(!(contains(@$stderr_buf30[0], "ERROR")))
{
    exit(1);
}

# Test to ensure that a database name must be provided:

my $cmd31 = qq($homedir/nodectl spock repset-create $database);
print("cmd31 = $cmd31\n");
my ($success31, $error_message31, $full_buf31, $stdout_buf31, $stderr_buf31)= IPC::Cmd::run(command => $cmd31, verbose => 0);
print("stdout_buf31 = @$stdout_buf31\n");
if(!(contains(@$stderr_buf31[0], "ERROR")))
{
    exit(1);
}

# Create the replication set:

my $cmd3 = qq($homedir/nodectl spock repset-create $repset $database);
print("cmd3 = $cmd3\n");
my ($success3, $error_message3, $full_buf3, $stdout_buf3, $stderr_buf3)= IPC::Cmd::run(command => $cmd3, verbose => 0);
print("stdout_buf3 = @$stdout_buf3\n");

print("We just executed the command that creates the replication set (demo-repset) on $n1\n");

# Test to confirm that cluster is set up.

print("We just installed pgedge/spock in $n1.\n");

if(contains(@$stdout_buf3[0], "repset_create"))

{
    exit(0);
}
else
{
    exit(1);
}





