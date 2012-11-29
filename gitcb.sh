#!/bin/sh

#git st 2>/dev/null | head -1 | cut -d ' ' -f 4
git symbolic-ref -q HEAD | sed s:refs/heads/::
