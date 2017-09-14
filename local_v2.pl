#!/usr/bin/perl

#version 2.0

#Installation Instructions - Using CPAN
#cpan install XML::Simple
#cpan install LWP::Simple
#cpan install Data::Dumper

#use strict;
use warnings;
use XML::Simple;
use LWP::Simple;
use Data::Dumper;
# Turn off output buffering
$|=1;

print "Enter your NPA\n";
my $inputnpa = <STDIN>;
chomp $inputnpa;
print "Enter your NXX\n";
my $inputnxx = <STDIN>;
chomp $inputnxx;
my $url = "http://localcallingguide.com/xmllocalprefix.php?npa=$inputnpa&nxx=$inputnxx";

my $data = get($url);


print "\nDownloading ....";

my $parser = new XML::Simple;
    
print "\nParsing ...";
my $dom = $parser->XMLin($data);

print "\n\n";
   
foreach my $e (@{$dom->{'lca-data'}->{'prefix'}})
{
	
my $npa = $e->{npa};
my $nxx = $e->{nxx};
 
 print "dial-peer voice $npa$nxx pots\n" ;
 print "destination-pattern +1$npa$nxx....\n" ;
 print "trunkgroup PRI\n" ;
 print "forward-digits 10\n";
 print "\!\n" ;

 push( @dialpeers, "dial-peer voice $npa$nxx pots\n" );
 push( @dialpeers, "destination-pattern +1$npa$nxx....\n" );
 push( @dialpeers, "trunkgroup PRI\n" );
 push( @dialpeers, "forward-digits 10\n");
 push( @dialpeers, "\!\n" );

}

    my $filename = 'dialpeers.txt';
    open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
    
    

foreach  my $LINE ( @dialpeers )  { 
    chomp ( $LINE );
    print $fh "$LINE\n";  
}

close $fh;
   




