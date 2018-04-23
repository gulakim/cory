#!/usr/bin/perl
#------------------------------------------------------------------------------

#   global setting

$THIS   = "area2xls";

$HELP_MESSAGE   = "
    $THIS converts Synopsys DC area report to MS-Excel file (.csv)
    
syntax>
    $THIS <synopsys_dc_area_report_filename>
    $THIS <synopsys_dc_area_report_filename> <xls_filename>
    $THIS -r <synopsys_dc_area_report_filename> -x <xls_filename>
    $THIS -r=<synopsys_dc_area_report_filename> -x=<xls_filename>
    $THIS <synopsys_dc_area_report_filename> -l=3
    $THIS -h

option>
    -r <area_report_filename>
    -r=<area_report_filename>
        specify the area report file generated from Synopsys DC

    -x <xls_filename>
    -x=<xls_filename>
        specify the Excel readable file, if not specified using <area_report_filename> after
        replacing the file extension to .csv.

    -l <n>
    -l=<n>
        limit the level of hierarchy to report.
        -l=0 reports all level, -l=1 reports only top level.

    -u <n>
    -u=<n>
        specify the size of NAND gate, for area to gate conversion 
        default 2.822 for TSMC90G is used
    -tsmc65lp
        the same as -u=1.44
    -tsmc65g
        the same as -u=1.6
    -tsmc90g
        the same as -u=2.8224
    -tsmc80g
        the same as -u=2.8224
    -tsmc130g
        the same as -u=5.09
    -smic130
        the same as -u=5.0922

limitation>
    1. Library cells on top module (or sub module) are not reported.
        Total area of top module may be larger than sum of sub modules.

";

$option{MAX_ERROR}  = 10;
$option{VERBOSE}    = 1;

############################################################
#   argument parsing
############################################################
unless (@ARGV) { help (); }

for (my $i=0; $i<@ARGV; $i=$i+1) {
    my $arg = $ARGV[$i];
    if ($arg =~ m/^-/) {
        if (($arg =~ m/-verbose/) || ($arg =~ m/-v/)) {
            $option{VERBOSE}    = 1;
        } elsif (($arg =~ m/-debug/) || ($arg =~ m/-d/)) {
            $option{DEBUG}    = 1;
        } elsif (($arg =~ m/-quite/) || ($arg =~ m/-q/)) {
            $option{VERBOSE}    = 0;

        ########################################
        } elsif ($arg =~ m/-r=/) {
            $arg    =~ s/-r=//;
            $option{RPT_FILENAME}   = $arg;
        } elsif ($arg =~ m/-x=/) {
            $arg    =~ s/-x=//;
            $option{XLS_FILENAME}   = $arg;
        } elsif ($arg =~ m/-l=/) {
            $arg    =~ s/-l=//;
            $option{LEVEL_TO_REPORT}   = $arg;
        } elsif ($arg =~ m/-u=/) {
            $arg    =~ s/-u=//;
            $option{UNIT_AREA}   = $arg;

        ########################################
        } elsif ($arg =~ m/-r/) {
            $option{RPT_FILENAME}   = $ARGV[++$i];
        } elsif ($arg =~ m/-x/) {
            $option{XLS_FILENAME}   = $ARGV[++$i];
        } elsif ($arg =~ m/-l/) {
            $option{LEVEL_TO_REPORT}   = $ARGV[++$i];
        } elsif ($arg =~ m/-u/) {
            $option{UNIT_AREA}   = $ARGV[++$i];
        } elsif ($arg =~ m/-tsmc65lp/i) {
            $option{UNIT_AREA}   = 1.44;
        } elsif ($arg =~ m/-tsmc65g/i) {
            $option{UNIT_AREA}   = 1.6;
        } elsif ($arg =~ m/-tsmc90g/i) {
            $option{UNIT_AREA}   = 2.8224;
        } elsif ($arg =~ m/-tsmc80g/i) {
            $option{UNIT_AREA}   = 2.8224;
        } elsif ($arg =~ m/-tsmc130g/i) {
            $option{UNIT_AREA}   = 5.09;
        } elsif ($arg =~ m/-smic130/i) {
            $option{UNIT_AREA}   = 5.0922;

        ########################################
        } elsif ($arg =~ m/-h/) {
            message ("HELP");
        } else {
            message ("ERROR", "undefined option '$arg'");
        }
    } else {
        if (!defined $option{RPT_FILENAME}) { 
            $option{RPT_FILENAME}   = $arg;
        } elsif (!defined $option{XLS_FILENAME}) {
            $option{XLS_FILENAME}   = $arg;
        } else {
            message ("ERROR", "undefined additional argument '$arg'");
        }
    }
}


############################################################
#   start of main
############################################################

if (!defined $option{XLS_FILENAME}) {
    my $tmp = $option{RPT_FILENAME};
    my @tmp = split (/\//, $tmp);
    $tmp[@tmp-1]  =~ s/\..*//;
    $tmp[@tmp-1]  = $tmp[@tmp-1].".csv";
    $tmp    = join ('/', @tmp);
    $option{XLS_FILENAME}   = $tmp;
}

my @rpt    = file_read ($option{RPT_FILENAME});

build_module_info (\@rpt);
my @top_module  = find_top_module ();

my $max_depth   = 0;
for (my $i=0; $i<@top_module; $i++) {
    my $tmp    = find_module_depth (1, $top_module[$i]);
    if ($tmp > $max_depth) {
        $max_depth  = $tmp;
    }
}

if (defined $option{LEVEL_TO_REPORT}) {
    if (!($option{LEVEL_TO_REPORT} == 0) && ($option{LEVEL_TO_REPORT} < $max_depth)) {
        $max_depth  = $option{LEVEL_TO_REPORT};
    }
}

@xls;

if (!defined $option{UNIT_AREA}) {
    message ("WARNING", "Unit area for Nand gate not specified, using default 1.6 for TSMC65G");
    $option{UNIT_AREA}    = 1.6;
}

push (@xls, get_header_string ($max_depth, ","));

for (my $i=0; $i<@top_module; $i=$i+1) {
    report_area ($max_depth, 0, ",", $top_module[$i]);
}

if ($option{DEBUG}) {
    foreach $k (sort (keys %info)) {
        $v  = $info{$k};
        message ("DEBUG", "\%info hash : '$k' -> '$v'");
    }
}

file_write ($option{XLS_FILENAME}, \@xls);

exit (0);

############################################################
sub get_area_loc {
    my $max_depth   = shift;

    my @row = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
    my $loc = $row[$max_depth];

    if (!defined $info{AREA_LOC}) {
        $info{AREA_LOC} = 2;
    }
    $loc    = $loc."$info{AREA_LOC}";

    $info{AREA_LOC} = $info{AREA_LOC} + 1;

    return $loc;
}

sub get_unit_loc {
    my $max_depth   = shift;

    my @row = ("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
    my $loc = $row[$max_depth+3];

    $loc    = $loc."\$1";

    return $loc;
}

sub get_header_string {
    my $max_depth   = shift;
    my $seperator   = shift;
    my $xls = "";

    $xls    = "Module Name";

    for (my $i=0; $i<$max_depth; $i=$i+1) {
        $xls    = $xls.$seperator;
    }

    $xls    = $xls."Area,Gate,NAND2X1=,$option{UNIT_AREA}";
    $xls    = $xls."\n";

    return $xls;
}

sub report_area {
    my $max_depth   = shift;
    my $cur_depth   = shift;
    my $seperator   = shift;
    my $name        = shift;

    my $xls = "";

    for (my $i=0; $i<$max_depth; $i=$i+1) {
        if ($cur_depth == $i) {
            $xls    = $xls.$name;
        }
        $xls    = $xls.$seperator;
    }

    $xls    = $xls.$info{"$name.area"};

    my $area_loc    = get_area_loc ($max_depth);
    my $unit_loc    = get_unit_loc ($max_depth);
    $xls    = $xls.",=$area_loc/$unit_loc";

    $xls    = $xls."\n";
    push (@xls, $xls);

    if ($option{DEBUG}) { message ("DEBUG", "xls='$xls'"); };

    if ($max_depth <= ($cur_depth+1)) {
        return;
    }

    for (my $i=0; $i<$info{"$name.n_sub"}; $i=$i+1) {
        report_area ($max_depth, $cur_depth+1, $seperator, $info{"$name.sub_$i"});
    }
}

sub find_module_depth {
    my $depth   = shift;
    my $module  = shift;
    my $max_depth   = $depth;

    for (my $i=0; $i<$info{"$module.n_sub"}; $i=$i+1) {
        my $sub_module  = $info{"$module.sub_$i"};
        my $tmp         = find_module_depth ($depth +1, $sub_module);

        if ($option{DEBUG}) {
            message ("DEBUG", "$module : given = $depth, $sub_module : found = $tmp");
        }

        if ($tmp > $max_depth) { $max_depth = $tmp; }

    }

    return $max_depth;
}

############################################################
# %info
#   $info{"name.area"}      : has area of module "name"
#   $info{"name.n_sub"}     : has number of sub module of module "name"
#   $info{"name.sub_<num>"} : has name of sub module of module "name"
#   $info{"n_module"}       : has number of module
#   $info{"module_<num>"}   : has name of deign
############################################################

sub find_top_module {

    my @top_module;

    for (my $i=0; $i<$info{n_module}; $i++) {
        my $module  = $info{"module_$i"};

        if (!is_sub_module ($module)) {
            push (@top_module, $module);
        }
    }
    return @top_module;
}

sub is_sub_module {
    my $module  = shift;

    foreach $sub (keys %info) {
        if ($sub =~ m/\.sub_/) {
            my $sub_module   = $info{$sub};
            if ($sub_module eq $module) {
                return 1;
            }
        }
    }
    return 0;
}

sub build_module_info {
    my $line_ref    = shift;
    my @line        = @$line_ref;

    my $module  = "not found";
    $info{n_module} = 0;

    for (my $i=0; $i<@line; $i++) {
        chomp ($line[$i]);
        $line[$i]   =~ s/ +/ /;

        if ($module eq "not found") {
            #line looking for is :
            #Design : design_name
            if ($line[$i] =~ m/^Design : /) {
                $line[$i]   =~ s/ //g;
                ($tmp, $module) = split (/:/, $line[$i]);
                $info{"$module.n_sub"}  = 0;
            }
        } else {                                # module found
            #line looking for is :
            #Total 25 references                                 6032031.000000
            if ($line[$i] =~ m/^Total /) {
                ($tmp1, $tmp2, $tmp3, $area)    = split (/ +/, $line[$i]);
                $info{"$module.area"}   = $area;

                my $n_module    = $info{"n_module"};
                $info{"module_$n_module"}   = $module;
                $info{"n_module"}   = $info{"n_module"} + 1;

                $module = "not found";          # end of a module

            } else { 
                $line[$i]   =~ s/,//;
                @tmp    = split (/ +/, $line[$i]);

            #user designed block
            #line looking for is :
            #Reference          Library       Unit Area   Count    Total Area   Attributes
            #axi2axi                       86670.718750       1  86670.718750  b, h, n
                if (($tmp[1] =~ /\./) && ($tmp[2] > 0) && ($tmp[3] =~ m/\./)) {
                    $sub_module   = $tmp[0];
                    $sub_area   = $tmp[3];
                    add_sub_info ($module, $sub_module, $sub_area);
                }

            #library cells
            #line looking for is :
            #Reference          Library       Unit Area   Count    Total Area   Attributes
            #TIELO              slow           2.116800      42     88.905603
                elsif (($tmp[2] =~ /\./) && ($tmp[3] > 0) && ($tmp[4] =~ m/\./)) {
                    $sub_module   = $tmp[0];
                    $sub_area   = $tmp[4];
#                    add_sub_info ($module, $sub_module, $sub_area);
#                    add_sub_info ($module, $sub_module, $sub_area);
                }
            }
        }
    }
}

sub add_sub_info {
    my $module  = shift;
    my $sub_module    = shift;
    my $sub_area    = shift;

############################################################
#   you may wish to see the DW modules inside
############################################################
#    if ($sub_module =~ m/DW/) {
#        return;
#    }

    my $n_sub   = $info{"$module.n_sub"};
    $info{"$module.sub_$n_sub"} = $sub_module;
    $info{"$module.n_sub"}      = $n_sub + 1;

    if ((defined $info{"$sub_module.area"}) && ($info{"$sub_module.area"} != $sub_area)) {
        my $prev_area   = $info{"$sub_module.area"};
        message ("WARNING", "$sub_module area mismatch, $prev_area vs $sub_area");
    }
    $info{"$sub_module.area"}     = $sub_area;

    if (!defined $info{"$sub_module.n_sub"}) {
        $info{"$sub_module.n_sub"}    = 0; 
    }

    if ($option{DEBUG}) {
        message ("DEBUG", "module='$module', sub_module='$sub_module', sub_area='$sub_area'");
    }
}

############################################################
#   sub routine
############################################################
sub file_read {
    my $filename    = shift;
    my @line;

    if (open (FILE, $filename)) {

        if ($option{VERBOSE}) { message ("NOTE", "reading from '$filename'"); }

        while (<FILE>) {
            push (@line, $_);
        }
        close (FILE);
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

############################################################
#   help message
############################################################
sub message {
    my $type    = shift;
    my $message = shift;

    print $type.":".$message."\n";

    if ($type =~ m/error/i) {
        $option{n_error}    = $option{n_error} + 1;

        if ($option{n_error} >= $option{MAX_ERROR}) {
            print "FATAL: number of errors ($option{n_error}) exceeds the maximum ($option{MAX_ERROR}\n";
            exit (1);
        }
    } elsif ($type =~ m/warning/i) {
        $option{n_warning} = $option{n_warning} + 1;
    } elsif ($type =~ m/note/i) {
        $option{n_note}    = $option{n_note} + 1;
    } elsif ($type =~ m/fatal/i) {
        exit (1);
    } else {
        $option{"n_$type"}  = $option{"n_$type"} + 1;
    }
}

sub help {
    print $HELP_MESSAGE."\n";
    exit (2);
}
