#!/usr/bin/perl
# A general purpose form decoder for use with all forms.
# 
# what it does is accept any information from ANY HTML form
# formats it, and mails it. 
# 
# To operate properly, the form must have the following
# entries:
# <INPUT TYPE="hidden" NAME="FORM_NAME" VALUE="The Name of your form">        
# <INPUT TYPE="hidden" NAME="MAIL_TO" VALUE="person@to-get.mail.com">
# This way the person receiving the mail knows where it came from
# The MAIL_TO is the person you want to receive the submission
#
# 1997 by bruce gronich for the public domain.
#This program is intended to be used as a learning tool. It
#is given freely AS IS and comes with no warranty. The author
#is not responsible for any damages caused by its use or
#misuse.

#cp the funform.html to your html root directory.
#modify the funform.html to meet your needs.
#change the name of the path of the /cgi-bin/ if needed

#BNB SAYS- Configure this to your sendmail
$mail_program="C:/Winnt/Blat.exe";

#BNB SAYS- Set these options to meet your needs

#let SEND_MAIL="Y" when you are done testing and want mail to be sent
$SEND_MAIL="Y";

######################################################################
###### THIS IS WHERE OUR PROGRAM STARTS! #############################
######################################################################

#This first part of the program splits up our data and gets it
#ready for formatting and mailing.
  $i=0;
  read(STDIN,$temp,$ENV{'CONTENT_LENGTH'});
  @pairs=split(/&/,$temp);
  foreach $item(@pairs)
   {
    ($key,$content)=split(/=/,$item,2);
    $content=~tr/+/ /;
    $content=~s/%(..)/pack("c",hex($1))/ge;
    $fields{$key}=$content;
    $i++;
    $item{$i}=$key;
    $response{$i}=$content;
   }

#Re-assign a couple of variables for readability reasons
    $send_to = $fields{MAIL_TO};
    $form_id = $fields{FORM_NAME};
    $msg_from = $fields{E_MAIL};

 
#Set up our HTML Result Form
   print "Content-type: text/html\n\n";
   print "<HTML>\n";
   print "<HEAD>\n";
   print "<TITLE>Information submission result</TITLE>\n";
   print "</HEAD>\n";
   print "<BODY BGCOLOR=#FFFFFF LINK=#4133EF ALINK=FF0000 VLINK=#FF0000>\n";
   print "<CENTER>\n";

   if ($SEND_MAIL eq "Y")
     {
       open (MAIL, "|$mail_program") ||
            die "Unable to run mail program\n";
print MAIL <<__STOP_OF_HEADER__;
To: $send_to
From: $msg_from
Subject: $form_id RESPONSE

__STOP_OF_HEADER__
     }

   print "<H1>Your Request has been Submitted!</H1>\n";
   print "<A HREF=$ENV{'HTTP_REFERER'}>\n";
   print "<B>CLICK HERE!</B></A> To return to the previous page<P>\n";
   print "</CENTER>\n";
   print "<B>Here is the information you sent:</B><P>\n";
   print "<PRE>";
   print "<HR>\n";
   print "      SUBMISSION FORM: $form_id\n";
   print "      E-MAIL TARGET:   $send_to\n";
   print "<HR>\n";

   $i=1;
     while ( $item{$i} gt " ")
       {
         if ($SEND_MAIL eq "Y")
           {
             print MAIL "      $item{$i}:   $response{$i}\n";
           }
         print "      $item{$i}:   $response{$i}\n";
         $i++;
       }
   print "</PRE>";
   print "<HR>\n";
   print "</BODY>\n";
   print "</HTML>\n";

#CLOSE THE MAIL PROGRAM IF WE ARE MAILING
   if ($SEND_MAIL eq "Y")
      {
         close (MAIL);
      }

######################################################################
###### THIS IS WHERE OUR PROGRAM ENDS! ###############################
######################################################################



