#!/usr/bin/perl


print "Content-type: text/html\n\n";

print "VARS<P>";

print "<p>Environment:<br>\n";
foreach $e (sort keys %ENV) {
  print "<br><tt>$e => $ENV{$e}</tt>\n";
 }
