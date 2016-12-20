#!/usr/bin/env python3
"""
Convert bibtex to rst for our website.

File: bibtex2ourRST.py

NOTE:

    You'll need to clean up the bibtex file a little before using this script.
    Here are a few things:

        1. Remove the "file = " entry
        2. Remove the "keywords = " entry
        3. Replace all "booktitle" entries with "journal"
        4. Remove the file:// links in url
        5. Make sure each url has one link only

    After using this script, you'll still need to do a few things:

        1. Add links to the journals
        2. Correct sentence case etc.
        3. Get rid of LaTeX escapes

Copyright 2016 Ankur Sinha
Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import bibtexparser
import re

with open('bibtex.bib') as bibtex_file:
    bibtex_str = bibtex_file.read()

bib_database = bibtexparser.loads(bibtex_str)

for entry in bib_database.entries:
    if 'link' not in entry:
        link = "#"
    else:
        link = entry['link']

    authorlist = entry['author'].split(' and ')
    formattedauthorlist = []
    for author in authorlist:
        names = author.split(' ')
        surname = names.pop(0)[0:-1]
        othernames = ""
        for ns in names:
            othernames += ns[0] + "."
        formattedauthorlist.append(surname + ", " + othernames)

    # start printing
    # line 1 - title and link
    print("- `{} <{}>`__ |br|".format(entry['title'], link))
    # line 2 - authors
    print("  ", end="")
    for i in range(0, len(formattedauthorlist)):
        print("{}, ".format(formattedauthorlist[i]), end="")
        if i == (len(formattedauthorlist) - 2):
            print("& ", end="")
    print(" |br|")
    # line 3 - date, journal, etc
    print("  ", end="")
    print("{} in `{} <#>`__".format(
        entry['year'], entry['journal']), end="")
    if 'volume' in entry:
        print(", {}".format(entry['volume']), end="")
    if 'pages' in entry:
        print(", p. {}".format(entry['pages']), end="")
    print()
    print()
