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

package Autobilder;

#
# Private variables
use constant lclDebugger => Debugger->new('Autobilder');
#
#

#
# Private functions
my $PopulatePaths;
$PopulatePaths = sub {
  lclDebugger->Register('$PopulatePaths');
  lclDebugger->OpenHere();

  # Populate LICENSE headers

  # Populate INCLUDE headers

  # Populate CONDITIONAL INCLUDE headers

  # Populate EXTERNAL GLOBAL variables

  # Populate INTERNAL GLOBAL variables

  # Populate PRIVATE functions

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
    __inputsrc => shift;
    __outputsrc => shift;
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
