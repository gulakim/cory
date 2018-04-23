#!/usr/bin/perl
$THIS   = "find_cory.pl";
#-------------------------------------------------------------------------------
#   created by Jay Kim 2013~
#-------------------------------------------------------------------------------
$OS     = `uname -s`;
if ($OS eq "Linux") {
    $now    = `date +%Y%m%d-%H%M%S`;
} else {
    $now    = `date`;
}

$HELP_MESSAGE   = "
    $THIS 
    
syntax>
    $THIS <options> file1.v file2.v
    $THIS -h
    $THIS -find -cory=../../cory cory_queue.v
    $THIS -inst cory_queue.v

option>
    -find       : find cory modules used inside verilog files
        -beh    : also find behavioral models used inside verilog files
    -inst       : quick instantiation for verilog modules
        -wire   : show parameter/wire definition as comment
    -new        : starting a new cory module
limitation>
    1. 
";

$option{MAX_ERROR}  = 10;
$option{VERBOSE}    = 0;

#-------------------------------------------------------------------------------
#   argument parsing
#-------------------------------------------------------------------------------
unless (@ARGV) { help (); }

$option{ACTION} = "inst";           # default action 

$option{CORY_HOME}  = "../../cory"; # home for cory

$option{SEARCH_BEH} = 0;            # for find, search for beh dir

$option{SPACE_ALIGN}    = 16;       # for inst, port mapping alignment
$option{SPACE_INDENT}   = 4;        # for inst, indent
$option{SPACE_RANGE}    = 8;        # for inst, bit range align
$option{SPACE_PARAMETER}= 12;       # for inst, parameter name align

@file_list;

for (my $i=0; $i<@ARGV; $i=$i+1) {
    my $arg = $ARGV[$i];
    if ($arg =~ m/^-/) {
        if (($arg eq "-verbose") || ($arg =~ m/-v/)) {
            $option{VERBOSE}    = 1;
        } elsif (($arg eq "-debug") || ($arg =~ m/-d/)) {
            $option{DEBUG}    = 1;
        } elsif (($arg eq "-quite") || ($arg =~ m/-q/)) {
            $option{VERBOSE}    = 0;
        } elsif (($arg eq "-help") || ($arg =~ m/-h/)) {
            message ("HELP");

        } elsif ($arg =~ m/-cory=/) {
            $arg    =~ s/-cory=//;
            $option{CORY_HOME}   = $arg;

        } elsif ($arg eq "-cory") {
            $option{CORY_HOME}   = $ARGV[++$i];

        } elsif (($arg eq "-find") || ($arg =~ m/-f/)) {
            $option{ACTION} = "find";
            } elsif ($arg eq "-beh") {
                $option{SEARCH_BEH}   = 1;
    
        } elsif (($arg eq "-inst") || ($arg =~ m/-i/)) {
            $option{ACTION} = "inst";
            } elsif (($arg eq "-wire") || ($arg =~ m/-w/)) {
                $option{SHOW_WIRE}  = 1;

        } elsif (($arg eq "-new") || ($arg =~ m/-n/)) {
            $option{ACTION} = "new";

        } else {
            message ("ERROR", "undefined option '$arg'");
        }
    } else {
        push (@file_list, $arg);
    }
}

#-------------------------------------------------------------------------------
#   find_cory
#-------------------------------------------------------------------------------
%name_list;

sub find_cory {
    my $filename    = shift;

    if (-d $filename) {
        message ("WARNING", "$filename is not a file, please specify a file name");
    } elsif (-e $filename) {
        my @all_line    = file_read ($filename);

        my $line;
        foreach $line (@all_line) {
            chomp($line);
            $line =~ s/^\s+//;
            $line =~ s/#/ # /;
            $line =~ s/\(/ \( /;

            my ($name, $dummy) = split (/ /, $line);        # module name and others

            if ($line =~ m/^cory_/) {

                if (-e "$option{CORY_HOME}/beh/$name.v") {
                    if ($option{SEARCH_BEH}) {
                        $name_list{$name} = $name_list{$name} + 1;
                        find_cory ($option{CORY_HOME}."/beh/$name.v");
                    }
                } else {        # rtl
                    $name_list{$name} = $name_list{$name} + 1;
                    find_cory ($option{CORY_HOME}."/rtl/$name.v");
                }
            }
        }
    } elsif ($option{DEBUG}) {
        message ("WARNING", "$filename not exist");
    }
}

#-------------------------------------------------------------------------------
sub action_find_cory {
    foreach $file (@file_list) {
        find_cory ($file);
    }
    
    foreach $name (sort (keys %name_list)) {
        print "$name\n";
    }
}

#-------------------------------------------------------------------------------
#   inst cory
#-------------------------------------------------------------------------------
sub inst_cory {
    my  $filename   = shift;

    if (-d $filename) {
        message ("WARNING", "$filename is not a file, please specify a file name");
        return;
    }

         if (-e "$option{CORY_HOME}/rtl/$filename.v") {
        $filename   = "$option{CORY_HOME}/rtl/$filename.v";
    } elsif (-e "$option{CORY_HOME}/beh/$filename.v") {
        $filename   = "$option{CORY_HOME}/beh/$filename.v";
    } elsif (-e "$filename.v") {
        $filename   = "$filename.v";
    } else {
        message ("ERROR", "$filename not exists");
    }

    %info = {};
    load_info_inst_cory ($filename);
    show_info_inst_cory ();
}

#-------------------------------------------------------------------------------
%info;
sub load_info_inst_cory {
    my $filename    = shift;
    my @all_line    = file_read ($filename);
    my $line;

    foreach $line (@all_line) {
        chomp ($line);
        $line   =~ s/\/\/.*//;          # remove comments
        $line   =~ s/^\s+//g;           # remove preceeding spaces
        $line   =~ s/\s+$//;            # remove trailing spaces
        $line   =~ s/=//;               # remove parameter assignment "="
        $line   =~ s/,//;               # remove port separator ","
        $line   =~ s/\s+/ /g;           # have one space
            my $bits    = $line;            # num bits
        $line   =~ s/\[.*\]//;          # remove bus bits "[3:0]"
        $line   =~ s/\s+/ /g;           # have one space

            $bits   =~ s/.*\[//;            # [9:0]
            $bits   =~ s/\:0].*//;          # [A-1:0]
            if ($bits) {
                if ($bits =~ m/-1/) {
                    $bits   =~ s/-1//;
                    $bits   = $bits;
                } else {
                    $bits   = $bits + 1;
                }
            } else {
                $bits   = 1;
            }

        #   print "debug:line='$line'\n";

        my ($type, $name, $value)   = split (/ /, $line);

        if ($type eq "module") {
            $info{"0"}  = $name;
            $info{$name."type"} = $type;
            $info{count}    = 1;
        } elsif ($type eq "parameter") {
            $info{$info{count}} = $name;
            $info{$name."type"} = $type;
            $info{$name."value"}    = $value;
            $info{parameter."$name"}    = $value;
            $info{count}    = $info{count} + 1;
            $info{count_parameter}  = $info{count_parameter} + 1;
        } elsif (($type eq "input") || ($type eq "output") || ($type eq "inout")) {
            $info{$info{count}} = $name;
            $info{$name."type"} = $type;
            $info{$name."nbit"} = $bits;
            $info{count}    = $info{count} + 1;
            $info{count_port}  = $info{count_port} + 1;
        } elsif ($type eq ");") {
            return;
        }
    }
}

#-------------------------------------------------------------------------------
sub show_info_inst_cory {
    my @out_line;

    push (@out_line, "//------------------------------------------------------------------------------");
    if ($option{SHOW_WIRE}) {
        for (my $i=0; $i<$info{count}; $i=$i+1) {
            my $name    = $info{$i};
            my $type    = $info{$name."type"};
            my $nbit    = $info{$name."nbit"};
            my $value   = $info{$name."value"};
            my $line    = "";
            my $port_name   = $name;
            $port_name  =~ s/^[iob]_//;
    
            if ($type eq "parameter") {
                my $align   = get_space ($option{SPACE_PARAMETER} - length($name));
                $line   = "//  localparam $name$align= $value;";
            }
            if (($type eq "input") || ($type eq "output") || ($type eq "inout")) {
                if ($nbit == 1) {
                    $range  = "";
                } elsif (is_digit ($nbit)) {
                    $nbitm1 = $nbit-1;
                    $range  = "[$nbitm1:0]";
                } else {
                    $range  = "[$nbit-1:0]";
                }
                $align  = get_space ($option{SPACE_RANGE}-length($range));
                $line   = "//  wire    $range$align$port_name;";
            }
            if ($line) {
                push (@out_line, $line);
            }
        }
        push (@out_line, "//------------------------------------------------------------------------------");
    }
    for (my $i=0; $i<$info{count}; $i=$i+1) {
        my $name    = $info{$i};
        my $type    = $info{$name."type"};

        my $port_name   = $name;
        $port_name  =~ s/^[iob]_//;

        #   print "debug:i=$i, name=$name, type=$type\n";

        my $line    = "";
        my $align   = get_space ($option{SPACE_ALIGN}-1 - length ($name));        # .port
        my $indent  = get_space ($option{SPACE_INDENT});

        if (($type eq "module") && ($info{count_parameter})) {
            $line   = "$name #(";
            $module = $name;
        } elsif (($type eq "module") && ($info{counter_parameter}==0)) {
            $line   = "$name u_$name";
        } elsif (($type eq "parameter") && ($i < $info{count_parameter})) {
            $line   = "$indent.$name$align($name),";
        } elsif (($type eq "parameter") && ($i == $info{count_parameter})) {
            $line   = "$indent.$name$align($name)";
            push (@out_line, $line);
            $line   = ") u_$module (";
        } elsif ((($type eq "input") || ($type eq "output") || ($type eq "inout")) && ($i-$info{count_parameter} < $info{count_port})) {
            $line   = "$indent.$name$align($port_name),";
        } elsif ((($type eq "input") || ($type eq "output") || ($type eq "inout")) && ($i-$info{count_parameter} == $info{count_port})) {
            $line   = "$indent.$name$align($port_name)";
        }
        push (@out_line, $line);
    }
        push (@out_line, ");");

    foreach $line (@out_line) {
        print $line."\n";
    }

#       foreach $key (keys (%info)) {
#           print "debug:$key -> $info{$key}\n";
#       }
}

#-------------------------------------------------------------------------------
sub action_inst_cory {
    foreach $file (@file_list) {
        inst_cory ($file);
    }
}

#-------------------------------------------------------------------------------
#   new cory
#-------------------------------------------------------------------------------
@new_line   = (
"`ifndef CORY_XXX",
"    `define CORY_XXX",
"",
"//------------------------------------------------------------------------------",
"module cory_xxx # \(",
"    parameter   N   = 8",
"\) \(",
"    input           clk,",
"",
"    input           reset_n",
"\);",
"",
"//------------------------------------------------------------------------------",
"",
"//------------------------------------------------------------------------------",
"`ifdef  SIM",
"`endif  //  SIM",
"endmodule"
);

sub action_new_cory {
    foreach $line (@new_line) {
        print "$line\n";
    }
}

#-------------------------------------------------------------------------------
#   start of main
#-------------------------------------------------------------------------------

   if ($option{ACTION} eq "find") { action_find_cory (); }
elsif ($option{ACTION} eq "inst") { action_inst_cory (); }
elsif ($option{ACTION} eq "new")  { action_new_cory (); }
elsif ($option{ACTION} eq "help") { help (); }
else { 
    message ("ERROR", "$option{ACTION} not defined");
    help (); 
}

#-------------------------------------------------------------------------------
if ($option{n_error}) {
    exit (0);
} else {
    exit (1);
}

#-------------------------------------------------------------------------------
#   default sub routine
#-------------------------------------------------------------------------------
sub get_space {
    my  $len    = shift;
    my  $space;
    for (my $i=0; $i<$len; $i=$i+1) {
        $space  = $space." ";
    }
    return $space;
}

sub is_digit {
    my $str = shift;
    for (my $i=0; $i<length($str); $i=$i+1) {
        my $char = substr ($str, $i, 1);
        if (!(($char eq "0") ||
              ($char eq "1") ||
              ($char eq "2") ||
              ($char eq "3") ||
              ($char eq "4") ||
              ($char eq "5") ||
              ($char eq "6") ||
              ($char eq "7") ||
              ($char eq "8") ||
              ($char eq "9"))) {
            return 0;
        }
    }
    return 1;
}

sub file_read {
    my $filename    = shift;
    my @line;

    if (open (FILE, $filename)) {

        while (<FILE>) {
            push (@line, $_);
        }
        close (FILE);

        $line_num = @line;
        if ($option{VERBOSE}) { message ("NOTE", "reading from '$filename', $line_num line(s) loaded"); }
    } else {
        message ("FATAL", "cannot read from '$filename'");
    }

    return @line;
}

sub file_write {
    my $filename    = shift;
    my $line_ref    = shift;
    my @line    = @$line_ref;

    if (open (FILE, "> $filename")) {

        if ($option{VERBOSE}) { message ("NOTE", "writing to '$filename'"); }

        foreach $line (@line) {
            print FILE $line;
        }
        close (FILE);
    } else {
        message ("ERROR", "cannot write to '$filename'");
    }
}

#-------------------------------------------------------------------------------
#   help message
#-------------------------------------------------------------------------------
sub message {
    my $type    = shift;
    my $message = shift;

    print $type.":".$message."\n";

    if ($type =~ m/error/i) {
        $option{n_error}    = $option{n_error} + 1;

        if ($option{n_error} >= $option{MAX_ERROR}) {
            print "FATAL: number of errors ($option{n_error}) exceeds the maximum ($option{MAX_ERROR}\n";
            exit (0);
        }
    } elsif ($type =~ m/warning/i) {
        $option{n_warning} = $option{n_warning} + 1;
    } elsif ($type =~ m/note/i) {
        $option{n_note}    = $option{n_note} + 1;
    } elsif ($type =~ m/fatal/i) {
        exit (0);
    } else {
        $option{"n_$type"}  = $option{"n_$type"} + 1;
    }
}

sub help {
    print $HELP_MESSAGE."\n";
    exit (0);
}
