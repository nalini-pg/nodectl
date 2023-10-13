# This is part of a complex test case; after creating a two node cluster on the localhost, 
# the test case executes the commands in the Getting Started Guide at the pgEdge website.
#
# In this case, we'll drop table created on node 1.



use strict;
use warnings;
use File::Which;
use IPC::Cmd qw(run);
use Try::Tiny;
use JSON;
use lib './lib';
use contains;
use List::MoreUtils qw(pairwise);

# Our parameters are:

my $cmd99 = qq(whoami);
print("cmd99 = $cmd99\n");
my ($success99, $error_message99, $full_buf99, $stdout_buf99, $stderr_buf99)= IPC::Cmd::run(command => $cmd99, verbose => 0);
print("stdout_buf99 = @$stdout_buf99\n");

my $repuser = "@$stdout_buf99[0]";
my $username = "lcusr";
my $password = "password";
my $database = "lcdb";
my $version = "pg16";
my $spock = "3.1";
my $cluster = "demo";
my $repset = "demo-nodelete-repset";
my $n1 = "~/work/nodectl/test/pgedge/cluster/demo/n1";
my $n2 = "~/work/nodectl/test/pgedge/cluster/demo/n2";

# We can retrieve the home directory from nodectl in json form... 

my $json = `$n1/pgedge/nc --json info`;
# print("my json = $json");
my $out = decode_json($json);
my $homedir = $out->[0]->{"home"};
print("The home directory is {$homedir}\n"); 

# We can retrieve the port number from nodectl in json form...
my $json1 = `$n1/pgedge/nc --json info pg16`;
# print("my json = $json1");
my $out1 = decode_json($json1);
my $port = $out1->[0]->{"port"};
print("The port number is {$port}\n");




print("repuser before chomp = $repuser\n");
chomp($repuser);



      print ("-"x150,"\n");

     # Dropping public.foo_no_delete Table

    my $cmd6 = qq($homedir/$version/bin/psql -t -h 127.0.0.1 -p $port -d $database -c "DROP TABLE foo_no_delete");
    print("cmd6 = $cmd6\n");
    my($success6, $error_message6, $full_buf6, $stdout_buf6, $stderr_buf6)= IPC::Cmd::run(command => $cmd6, verbose => 0);
    print ("-"x150,"\n");


     my $cmd7 = qq($homedir/$version/bin/psql -t -h 127.0.0.1 -p $port -d $database -c "SELECT * FROM spock.tables");
     print("cmd7 = $cmd7\n");
     print("\n");
 my ($success7, $error_message7, $full_buf7, $stdout_buf7, $stderr_buf7)= IPC::Cmd::run(command => $cmd7, verbose => 0);
    
    

 


