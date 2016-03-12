#!/bin/bash

# Copyright 2016 Ankur Sinha 
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
# File : test.sh
#

python3_path=$(which python3)
gnuplot_path=$(which gnuplot)

# To combine Nest gdf files from various ranks, you can use the Linux sort command:
# sort -k "2" -n *.gdf > spikes-E-10001.gdf

if [ -x "$python3_path" ]; then
    echo "Running python script"
    python3 ../nest-spike2hz.py spikes-E-10001.gdf firing-rates.gdf
    echo "Firing rate file written."
    if [ -x "$gnuplot_path" ]; then
        gnuplot plotfiringrates.plt
    else
        echo "Could not find gnuplot - not plotting graph."
    fi
else
    echo "Could not find python3. Exiting"
fi
