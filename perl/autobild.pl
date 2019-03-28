#!/usr/bin/perl -w
# Autobild.pl -- The Perl Autobild.  Automagically build your source files!
# Copyright (C) 2019  Matt Rienzo
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Submit issues or pull requests at <https://github.com/casnix/autobild/>.

use strict;
use warnings;
use boolean ':all';
use FindBin; use lib $FindBin::Bin;

use GlobalEnvironment;
use Debugger;
use Autobilder;
#
# Global variables for internal use
use constant lclVersion => "0.0.1";
use constant lclDebugger => Debugger->new('autobild');
#
#

#
# Entry stub
{
  $GlobalEnvironment::DebuggerOn = true;
  lclDebugger->Register('entry');
  lclDebugger->OpenHere();

  my $status = Main($#ARGV, \@ARGV);
  print "Perl script exited with $status status\n";
  lclDebugger->CloseHere();

  exit($status);
}
#
#

# int Main($,$) -- The main function.
#-- Arguments: $argc, the argument count
#              $argv, a reference to the argument vector.
#-- Returns: An integer 0 or less for status.
sub Main {
  my $argc = shift;
  my $argv = shift;

  lclDebugger->Register('Main');
  lclDebugger->OpenHere();

  my($inputSrcParts, $outputSrcPath) = ProcessArguments($argc, $argv);
  lclDebugger->Note("\$inputSrcParts = ".$inputSrcParts);
  lclDebugger->Note("\$outputSrcPath = ".$outputSrcPath);

  lclDebugger->CloseHere();

  return -1;
}

# (string, string) ProcessArguments($,$) -- commandline argument processor
#-- Arguments: $argc, the argument count
#              $argv, a reference to the argument vector.
#-- Returns: @returnList, { the input source parts directory
#                           the output source path. }
sub ProcessArguments {
  lclDebugger->Register('ProcessArguments');
  lclDebugger->OpenHere();

  my $argc = shift;
  my $argv = shift;

  lclDebugger->Note("\$argc = ".$argc);
  lclDebugger->Note("\$argv = [ ".join(",", @{ $argv })." ]");

  my($inputSrcParts, $outputSrcPath) = ("", "");

  # Weirdly works online but not in CLI grep...?
  my $srcSwitches = qr/-(i|o)/;
  my $cmdSwitches = qr/-(w|h|v|d|-license|-help|-version|-debugger)/;

  # Iterate through arguments
  my $boolSkip = false;
  foreach my $argumentIndex (0..$argc){
    lclDebugger->Note("\$argv->[".$argumentIndex."] = ".$argv->[$argumentIndex]);
    if($boolSkip) {
      $boolSkip = false;
      next;
    }

    ($inputSrcParts = $argv->[$argumentIndex + 1]) if $argv->[$argumentIndex] eq "-i";
    ($outputSrcPath = $argv->[$argumentIndex + 1]) if $argv->[$argumentIndex] eq "-o";

    if($argv->[$argumentIndex] =~ $srcSwitches) {
      $boolSkip = true;
      next;
    }

    PrintGPLNotice() if ($argv->[$argumentIndex] eq "-w" || $argv->[$argumentIndex] eq "--license");
    UsageDie() if $argv->[$argumentIndex] eq "-h" || $argv->[$argumentIndex] eq "--help";
    PrintVersion() if $argv->[$argumentIndex] eq "-v" || $argv->[$argumentIndex] eq "--version";
    EnableDebugger() if $argv->[$argumentIndex] eq "-d" || $argv->[$argumentIndex] eq "--debugger";

    UsageDie() unless $argv->[$argumentIndex] =~ $cmdSwitches;
  }

  lclDebugger->CloseHere();
  return($inputSrcParts, $outputSrcPath);
}

# void UsageDie(void) -- print the usage message and exit the program
#-- Arguments: none
#-- Returns: nothing, exits.
sub UsageDie {
  lclDebugger->Register('UsageDie');
  lclDebugger->OpenHere();

  die ("Usage: autobild.pl [-whvd|-license|-help|-version|-debugger] [-(i|o)] filepath\n".
    "Options: -i                            The input source parts directory path.\n".
    "         -o                            The output source file path.\n".
    "         -w --license                  Print GPLv3.0 notice.\n".
    "         -h --help                     Print usage message.\n".
    "         -v --version                  Print version.\n".
    "         -d --debugger                 Enable the built in debugger (for autobild developers).\n".
    "Created by Matt Rienzo, 2019.\n");

  lclDebugger->CloseHere();
}

# void PrintGPLNotice(void) -- Prints the GPLv3 notice.
#-- Arguments: None.
#-- Returns: Nothing.
sub PrintGPLNotice {
  die ("Autobild.pl -- The Perl Autobild.  Automagically build your source files!\n".
  "Copyright (C) 2019  Matt Rienzo\n".
  "\n".
  "This program is free software: you can redistribute it and/or modify\n".
  "it under the terms of the GNU General Public License as published by\n".
  "the Free Software Foundation, either version 3 of the License, or\n".
  "(at your option) any later version.\n".
  "\n".
  "This program is distributed in the hope that it will be useful,\n".
  "but WITHOUT ANY WARRANTY; without even the implied warranty of\n".
  "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n".
  "GNU General Public License for more details.\n".
  "\n".
  "You should have received a copy of the GNU General Public License\n".
  "along with this program.  If not, see <https://www.gnu.org/licenses/>.\n".
  "\n".
  "Submit issues or pull requests at <https://github.com/casnix/autobild/>.\n");
}

# void PrintVersion(void) -- Prints the version.
#-- Arguments: None.
#-- Returns: Nothing.
sub PrintVersion {
  die ("Autobild.pl -- The Perl Autobild.  Automagically build your source files!\n".
  "Version: ".lclVersion."\n".
  "Copyright (C) 2019 Matt Rienzo\n");
}

# void EnableDebugger(void) -- Enables the built in debugger.
#-- Arguments: None.
#-- Returns: Nothing.
sub EnableDebugger {
  $GlobalEnvironment::DebuggerOn = true;
}
