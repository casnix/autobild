# Autobilder.pm -- The Perl Autobild.  Automagically build your source files!
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

use Parse::CSV;

use GlobalEnvironment;
use Debugger;
use Autobilder::FSModel;

package Autobilder;

#
# Private variables
use constant lclDebugger => Debugger->new('Autobilder');
#
#

#
# Private functions declared
my $PopulatePaths;
my $PopulateGlobals;
my $PopulatePrivate;
my $PopulateEntries;
my $PopulatePublics;
my $PopulateFooters;

my $Message;
my %Messenger;
#
#

#
# Private functions implemented

# void $Message($ or %) -- Prints a message depending on level.
#-- Arguments: Two uses:
# 1-           $msg, the message to print at level 1.
# 2-           %msg => {level => n, msg => str}, a hash defining level and msg to print at specified msg.
#- Returns: Nothing.
$Message = sub {
  if($GlobalEnvironment::Silent) return;

  if(ref eq "SCALAR") $Messenger{Levels}->[1](shift);
  if(ref eq "HASH") $Messenger{Levels}->[$_[0]->{level}]($_[0]->{msg});
}

# void $PopulatePaths(void) -- Populate parts paths.
#-- Arguments: None.
#-- Returns: Nothing.
$PopulatePaths = sub {
  lclDebugger->Register('$PopulatePaths');
  lclDebugger->OpenHere();

  my $this = shift;

  $this->{__fsModel} = Autobilder::FSModel->new($this->{__inputsrc});
  $this->{private}->{__fsModel} = Autobilder::FSModel->new($this->{__inputsrc}."/_");

  my $privModel = ${ $this->{private}->{__fsModel} };
  my $nodeModel = ${ $this->{__fsModel} };

  $this->$PopulateHeaders(\$nodeModel);
  $this->$PopulateGlobals(\$nodeModel);
  $this->$PopulatePrivate(\$privModel);
  $this->$PopulateEntries(\$nodeModel);
  $this->$PopulatePublics(\$nodeModel);
  $this->$PopulateFooters(\$nodeModel);

  lclDebugger->CloseHere();
}

# void $PopulateHeaders($) -- Populate header paths
#-- Arguments: \$nodeModel, a reference to the FSModel.
#-- Returns: Nothing.
$PopulateHeaders = sub {
  lclDebugger->Register('$PopulateHeaders');
  lclDebugger->OpenHere();

  my $this = shift;
  my $node = shift;

  # Populate LICENSE headers
  $this->{paths}->{LICENSE} = ${ $node }->FilterFor('license.headers');
  # Populate INCLUDE headers
  $this->{paths}->{INCLUDE} = ${ $node }->FilterFor('include.headers');
  # Populate CONDITIONAL INCLUDE headers
  $this->{paths}->{CONDITIONAL_INCLUDE} = ${ $node }->FilterFor('headers.conditional');

  lclDebugger->CloseHere();
}

# void $PopulateGlobals($) -- Populate global paths
#-- Arguments: \$nodeModel, a reference to the FSModel.
#-- Returns: Nothing.
$PopulateGlobals = sub {
  lclDebugger->Register('$PopulateGlobals');
  lclDebugger->OpenHere();

  my $this = shift;
  my $node = shift;

  # Populate EXTERNAL GLOBAL variables
  $this->{paths}->{EXTGLBLVAR} = $nodeModel->FilterFor('global.vars.external');
  # Populate INTERNAL GLOBAL variables
  $this->{paths}->{INTGLBLVAR} = $nodeModel->FilterFor('global.vars.internal');

  lclDebugger->CloseHere();
}

# void $PopulatePrivate($) -- Populate private paths.
#-- Arguments: \$privModel, a reference to the FSModel.
#-- Returns: Nothing.
$PopulatePrivate = sub {
  lclDebugger->Register('$PopulatePrivate');
  lclDebugger->OpenHere();

  my $this = shift;
  my $node = shift;

  # Populate scalars
  my @scalars = ${ $node }->FilterFor('DollarSign');
  my $scNode = -1;
  $scNode = Autobilder::FSModel->new($this->{__inputsrc}."_/".$scalars[0]) unless $#scalars < 0;

  # Populate lists
  my @lists = ${ $node }->FilterFor('ArraySign');
  my $liNode = -1;
  $liNode = Autobilder::FSModel->new($this->{__inputsrc}."_/".$lists[0]) unless $#lists < 0;

  # Populate PRIVATE functions
  $this->{paths}->{private}->{SCALAR}->{functions} = -1;
  $this->{paths}->{private}->{SCALAR}->{functions} = $scNode->FilterFor('code.sub') unless $scNode < 0;

  $this->{paths}->{private}->{LIST}->{functions} = -1;
  $this->{paths}->{private}->{LIST}->{functions} = $liNode->FilterFor('code.sub') unless $liNode < 0;

  # Populate ENTRY point

  # Populate PUBLIC functions

  # Populate FOOTER.
}
#
#

#
# Public functions

# Autobilder new($,$) -- Autobilder constructor.
#-- Arguments: $inputSrcParts, the path to the source parts
#              $outputSrcPath, the path to the output source file.
#-- Returns: Blessed reference.
sub new {
  lclDebugger->Register('new');
  lclDebugger->OpenHere();

  my $class = shift;

  my $self = {
    __inputsrc => shift,
    __outputsrc => shift,
    __fsModel => "",
    private => {
      __fsModel => "",
      SCALAR => "",
      LIST => "",
    },
    parts => {
      private => {
        SCALAR => { },
        LIST => { },
      },
    },
    paths => {
      private => {
        SCALAR => { },
        LIST => { },
      },
    },
  };

  lclDebugger->CloseHere();
  return bless $self, $class;
}

# void Init(class) -- Initialize objects.
#-- Arguments: None.
#-- Returns: Nothing.
sub Init {
  lclDebugger->Register('Init');
  lclDebugger->OpenHere();

  my $this = shift;

  # File paths
  $this->{paths} = { };
  $this->$PopulatePaths();
}

# int MashParts(class) -- Mash parts together to make a source file.
#-- Arguments: None.
#-- Returns: $status, the status.
sub MashParts {
  my $this = shift;

  $this->{paths} = { };

  # License header

}

#
#
