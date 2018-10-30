#!/usr/bin/env python

import re
import os
from os import path

outs = [open(x, 'w') for x in ['_vimrc', path.join('vimfiles', 'init.vim')]]
skip = re.compile(r'^\s*(?:"|$)')

search_dir = 'vimconfigs'

for f in sorted(os.listdir(search_dir)):
    if f.endswith('.txt') or f.endswith('.vim'):
        with open(path.join(search_dir, f)) as h:
            for l in h:
                l = l.rstrip()
                if not skip.match(l):
                    for x in outs:
                        x.write(l+'\n')

for x in outs:
    x.close()
