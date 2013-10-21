#!/usr/bin/perl -T

use strict;
use warnings;

#
##  Calomel.org  ,:,  Download Youtube videos and music using wget
##    Script Name : youtube_wget_video.pl
##    Version     : 0.34
##    Valid from  : May 2013
##    URL Page    : https://calomel.org/youtube_wget.html
##    OS Support  : Linux, Mac OSX, OpenBSD, FreeBSD or any system with perl
#                `:`
## Two arguments
##    $1 Youtube URL from the browser
##    $2 prefix to the file name of the video (optional)
#

############  options  ##########################################

# Option: what file type do you want to download? The string is used to search
# in the youtube URL so you can choose mp4, webm, avi or flv.  mp4 seems to
# work on the most players like android, ipod, ipad, iphones, vlc and mplayer.
my $fileType = "mp4";

# Option: what visual resolution or quality do you want to download? List
# multiple values just in case the highest quality video is not available, the
# script will look for the next resolution. You can choose "highres" for 4k
# (4096x2304), "hd1080" for 1080p, "hd720" for 720p, "itag=18" which means
# standard definition 640x380 and "itag=17" which is mobile resolution 144p
# (176x144). The script will always prefer to download the highest resolution
# video format from the list if available. Do not download highres 4k content
# unless you have a 4k tv. That would just be silly.
my $resolution = "hd1080,hd720,itag=18";

# Option: How many times should the script retry the download if wget fails for
# any reason? Do not make this too high as a reoccurring error will just hit
# youtube over and over again. A value of 3 to 10 works well.
my $retryTimes = 5;

# Option: do you want the resolution of the video in the file name? zero(0) is
# no and one(1) is yes. This option simply puts "_hd1080.mp4" or similar at the
# end of the file name.
my $resolutionFilename = 0;

# Option: turn on DEBUG mode. Use this to reverse engineering this code if you are
# making changes or you are building your own youtube download script.
my $DEBUG=0;

#################################################################

## clear the environment and set our path
$ENV{ENV} ="";
$ENV{PATH} = "/bin:/usr/bin:/usr/local/bin";

## initialize retry loop and resolution variables
my $prefix = "";
my $retry = 1;
my $retryCounter = 0;
my $resFile = "unknown";
my $user_url = "";
my $user_prefix = "";
my $url = "";

## collect the URL from the command line argument and untaint the input
if (defined($ARGV[0])) {
    chomp($user_url = $ARGV[0]);
        $url = "$1" if ($user_url =~ m/^([a-zA-Z0-9\-\&\?\=\:\.\/\_]+)$/ or die "\nError: Illegal characters in YouTube URL\n\n" );
        } else {
            print "\nError: You Must specify a Youtube URL\n\n";
                exit;
                }
                
                ## declare the user defined file name prefix if specified and untaint the input
                if (defined($ARGV[1])) {
                   chomp($user_prefix = $ARGV[1]);
                      $prefix = "$1" if ($user_prefix =~ m/^([a-zA-Z0-9\_\-\.\ ]+)$/ or die "\nError: Illegal characters in filename prefix\n\n" );
                      }
                      
                      ## retry getting the video if the script fails for any reason
                      while ( $retry != 0 && $retryCounter < $retryTimes ) {
                      
                      ## download the html code from the youtube page suppling the page title and the
                      ## video url. The page title will be used for the local video file name and the
                      ## url will be sanitized and passed to wget for the download.
                      my $html = `wget -Ncq -e convert-links=off --keep-session-cookies --save-cookies /dev/null --no-check-certificate "$url" -O-`  or die  "\nThere was a problem downloading the HTML file or the video is not open to the public.\n\n";
                      
                      ## format the title of the page to use as the file name
                      my ($title) = $html =~ m/<title>(.+)<\/title>/si;
                      $title =~ s/[^\w\d]+/_/g or die "\nError: title of the HTML page not found. Check the URL.\n\n";
                      $title =~ s/_youtube//ig;
                      $title =~ s/^_//ig;
                      $title = lc ($title);
                      $title =~ s/_amp//ig;
                      
                      ## collect the URL of the video from the HTML page
                      my ($download) = $html =~ /"url_encoded_fmt_stream_map"(.*)/ig;
                      
                      # Print all of the separated strings in the HTML page
                      print "\n$download\n\n" if ($DEBUG == 1);
                      
                      # This is where we look through the HTML code and select the file type and
                      # video quality. 
                      my @urls = split(',', $download);
                      OUTERLOOP:
                      foreach my $val (@urls) {
                      #   print "\n$val\n\n";
                      
                          if ( $val =~ /$fileType/ ) {
                                 my @res = split(',', $resolution);
                                        foreach my $ress (@res) {
                                                 if ( $val =~ /$ress/ ) {
                                                          print "\n\nGOOD\n\n" if ($DEBUG == 1);
                                                                   print "$val\n" if ($DEBUG == 1);
                                                                            $resFile = $ress;
                                                                                     $resFile = "sd640" if ( $ress =~ /itag=18/ );
                                                                                              $resFile = "mb144" if ( $ress =~ /itag=17/ );
                                                                                                       $download = $val;
                                                                                                                last OUTERLOOP;
                                                                                                                         }
                                                                                                                                }
                                                                                                                                    }
                                                                                                                                    }
                                                                                                                                    
                                                                                                                                    ## clean up the url by translating unicode and removing unwanted strings
                                                                                                                                    $download =~ s/\:\ \"//;
                                                                                                                                    $download =~ s/%3A/:/g;
                                                                                                                                    $download =~ s/%2F/\//g;
                                                                                                                                    $download =~ s/%3F/\?/g;
                                                                                                                                    $download =~ s/%3D/\=/g;
                                                                                                                                    $download =~ s/%252C/%2C/g;
                                                                                                                                    $download =~ s/%26/\&/g;
                                                                                                                                    $download =~ s/sig=/signature=/g;
                                                                                                                                    $download =~ s/\\u0026/\&/g;
                                                                                                                                    $download =~ s/(type=[^&]+)//g;
                                                                                                                                    $download =~ s/(fallback_host=[^&]+)//g;
                                                                                                                                    $download =~ s/(quality=[^&]+)//g;
                                                                                                                                    
                                                                                                                                    ## collect the url and sig since the html page randomizes their order
                                                                                                                                    my ($signature) = $download =~ /(signature=[^&]+)/;
                                                                                                                                    my ($youtubeurl) = $download =~ /(http?:.+)/;
                                                                                                                                    $youtubeurl =~ s/&signature.+$//;
                                                                                                                                    
                                                                                                                                    ## combine the url and sig in order
                                                                                                                                    $download = "$youtubeurl\&$signature";
                                                                                                                                    
                                                                                                                                    ## a bit more cleanup as youtube 
                                                                                                                                    $download =~ s/&+/&/g;
                                                                                                                                    $download =~ s/&itag=\d+&signature=/&signature=/g;
                                                                                                                                    
                                                                                                                                    ## combine file variables into the full file name
                                                                                                                                    my $filename = "unknown";
                                                                                                                                    if ( $resolutionFilename == 1 ) {
                                                                                                                                       $filename = "$prefix$title\_$resFile.$fileType";
                                                                                                                                         } else {
                                                                                                                                            $filename = "$prefix$title.$fileType";
                                                                                                                                            }
                                                                                                                                            
                                                                                                                                            ## Process check: Are we currently downloading this exact same video? Two of the
                                                                                                                                            ## same wget processes will overwrite themselves and corrupt the video.
                                                                                                                                            my $running = `ps auwww | grep [w]get | grep -c "$filename"`;
                                                                                                                                            print "\nNumber of the same wgets running: $running\n" if ($DEBUG == 1);
                                                                                                                                            if ($running >= 1)
                                                                                                                                              {
                                                                                                                                                 print "\nAlready downloading the same filename, exiting: $filename\n";
                                                                                                                                                    exit 0;
                                                                                                                                                      };
                                                                                                                                                      
                                                                                                                                                      ## Print the long, sanitized youtube url for testing and debugging
                                                                                                                                                      print "\n$download\n" if ($DEBUG == 1);
                                                                                                                                                      
                                                                                                                                                      ## print the file name of the video collected from the web page title for us to see on the cli
                                                                                                                                                      print "\n Download: $filename\n\n";
                                                                                                                                                      
                                                                                                                                                      ## Background the script. Use "ps" if you need to look for the process
                                                                                                                                                      ## running or use "ls -al" to look at the file size and date.
                                                                                                                                                      fork and exit;
                                                                                                                                                      
                                                                                                                                                      ## Download the video 
                                                                                                                                                      system("wget", "-Ncq", "-e", "convert-links=off", "--load-cookies", "/dev/null", "--tries=200", "--timeout=20", "--no-check-certificate", "$download", "-O", "$filename");
                                                                                                                                                      
                                                                                                                                                      ## Print the error code of wget
                                                                                                                                                      print "     error code: $?\n" if ($DEBUG == 1);
                                                                                                                                                      
                                                                                                                                                      ## Exit Status: Check if the file exists and we received the correct error code
                                                                                                                                                      ## from system call. If the download experienced any problems the script will run again and try
                                                                                                                                                      ## continue the download till the file is downloaded.
                                                                                                                                                      
                                                                                                                                                      if( $? == 0 && -e "$filename" && ! -z "$filename" )
                                                                                                                                                         {
                                                                                                                                                               print " Finished: $filename\n\n" if ($DEBUG == 1);
                                                                                                                                                                     $retry = 0;
                                                                                                                                                                        }
                                                                                                                                                                         else
                                                                                                                                                                            {
                                                                                                                                                                                 print STDERR "\n FAILED: $filename\n\n" if ($DEBUG == 1);
                                                                                                                                                                                     $retry = 1;
                                                                                                                                                                                         $retryCounter++;
                                                                                                                                                                                             sleep $retryCounter;
                                                                                                                                                                                                }
                                                                                                                                                                                                }
                                                                                                                                                                                                
                                                                                                                                                                                                #### EOF #####