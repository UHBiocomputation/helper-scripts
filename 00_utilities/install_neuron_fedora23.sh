#!/bin/bash

# Copyright 2015 Ankur Sinha 
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# File : install_neuron_fedora23.sh

NEURONDIR="$HOME/neuron"
SOURCESIR="$NEURONDIR/sources"
ARCH="x86_64"

usage ()
{
    echo "install_neuron_fedora23.sh"
    echo "Usage:"
    echo "Installs neuron on a Fedora 23 system in ~/neuron/."
    echo "Please run the following command to install the required build dependencies before proceeding:"
    echo "sudo dnf install xorg-x11-server-devel chrpath libtiff-devel imake libX11-devel automake autoconf libtool libXext-devel ncurses-devel iv-devel readline-devel Cython automake autoconf python2-devel openmpi-devel"
    echo "Please modify the script as required - for example the flag being passed to make, or the versions of neuron and iv you intend to use."

    exit 0
}

run ()
{
    mkdir -p "$SOURCESIR"

    pushd "$SOURCESIR"
        wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/iv-19.tar.gz
        wget http://www.neuron.yale.edu/ftp/neuron/versions/v7.4/nrn-7.4.tar.gz
    popd
    echo "Sources have been downloaded to $SOURCESIR"

    cd "$NEURONDIR"
    tar -xvf "SOURCESIR"/*.tar.gz

    mv iv-* iv
    mv nrn-* nrn

    pushd iv
        ./configure --prefix="$NEURONDIR"
        make -j16
        make install
    popd

    pushd nrn
        ./configure --prefix="$NEURONDIR" --with-iv="$NEURONDIR/iv" --with-x
        make -j16
        make install
    popd

    echo "source $NEURONDIR/nrnenv >> $HOME/.bashrc"

    cat > "$NEURONDIR/nrnenv" <<EOF
export IV="$NEURONDIR/iv"
export N="$NEURONDIR/nrn"
# for this concrete example, we assume hostcpu is i686
export CPU="$ARCH"
export PATH="$IV/$CPU/bin:$N/$CPU/bin:$PATH"
EOF

    echo "Please either log out and log back in or source $HOME/.bashrc on all open terminals."
    echo "Complete."
}
